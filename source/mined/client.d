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
		Buffer _packetBuffer;
	}

	this(Server server, Socket socket)
	{
		_server = server;
		_socket = socket;
	}

	void appendBuffer(Buffer buf)
	{
		_packetBuffer ~= buf;
	}

	void processBuffer()
	{
		import app;
		while (true)
		{
			if (_packetBuffer.length == 0)
				break;

			int nRead = 0;
			int packetLength = VarInt.peek(_packetBuffer, nRead).value;
			logDev("Packet lengt: %d, bytes read: %d", packetLength, nRead);

			if (packetLength > _packetBuffer.length)
				break;

			dispatchPacket(_packetBuffer[nRead .. packetLength + 1], packetLength);
			_packetBuffer = _packetBuffer[packetLength + 1 .. $];
			logDev("Consumed buffer");
			printBuffer(_packetBuffer);
		}
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

		if (_state == GameState.HANDSHAKING)
		{
			switch (packetType)
			{
				case 0x00:
					_state = HandshakeHandler(this).handle(buffer);
					break;
				default:
					throw new Exception("Packet 0x%x not implemented for state %d!".format(packetType, _state));
			}
		}
		else if (_state == GameState.STATUS)
		{
		}
		else if (_state == GameState.LOGIN)
		{
			switch (packetType)
			{
				case 0x00:
					_state = LoginStartHandler(this).handle(buffer);
					break;
				default:
					throw new Exception("Packet 0x%x not implemented for state %d!".format(packetType, _state));
			}
		}
		else
			throw new Exception("State %d not implement (packet: %d)".format(_state, packetType));
	}

	void close()
	{
		_socket.shutdown(SocketShutdown.BOTH);
		_socket.close();
	}
}
