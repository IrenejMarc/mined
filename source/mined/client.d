// Represents a client connection
module mined.client;

import std.socket;
import std.conv : to;
import std.string : format;

import mined.util.buffer;
import mined.types.varint;
import mined.util.logging;
import mined.server;
import mined.gamestate;


class Client
{
	private
	{
		Server _server;
		Socket _socket;
		GameState _state;
	}

	this(Server server, Socket socket)
	{
		_server = server;
		_socket = socket;
	}

	void write(ConstBuffer buffer)
	{
		_socket.send(buffer);
	}

	void reply(Socket client, Buffer data)
	{
		data = VarInt(data.length.to!int) ~ data;

		logDev("Writing %s", data);
		client.send(VarInt(data.length.to!int).get ~ data);
	}

	void dispatchPacket(Buffer buffer, int length)
	{
		import mined.handlers.handshake;
		import mined.handlers.loginstart;
		import std.bitmanip : read;

		auto packetType = VarInt.read(buffer).value;

		logDev("Dispatching packet type %d of length %d", packetType, length);

		final switch (_state)
		{
			case GameState.HANDSHAKING:
				switch (packetType)
				{
					case 0x00:
						HandshakeHandler(this).handle(buffer);
						break;
					default:
						throw new Exception("Packet 0x%x not implemented for state %d!".format(packetType, _state));
				}
				break;
			case GameState.STATUS: break;
			case GameState.LOGIN:
				switch (packetType)
				{
					case 0x00:
						LoginStartHandler(this).handle(buffer);
						break;
					default:
						throw new Exception("Packet 0x%x not implemented for state %d!".format(packetType, _state));
				}

		}
	}

	void close()
	{
		_socket.shutdown(SocketShutdown.BOTH);
		_socket.close();
	}
}
