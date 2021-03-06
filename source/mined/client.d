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
import mined.packet;


class Client
{
	private
	{
		Server _server;
		Socket _socket;
		GameState _state;
		Buffer _packetBuffer;
	}

	ClientSettings settings;

	@property const state()
	{
		return _state;
	}

	@property const server()
	{
		return _server;
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
		import mined.packet;

		while (true)
		{
			if (_packetBuffer.length == 0)
				break;


			int nRead = 0;
			int packetLength = VarInt.peek(_packetBuffer, nRead).value;

			if (packetLength > _packetBuffer.length)
				break;

			Packet packet = Packet.read(_packetBuffer);
			logDev(" * Packet is: %s", packet);
			dispatchPacket(packet);

			logDev("* Remaining buffer: %s", _packetBuffer);
		}
	}

	void write(Packet packet)
	{
		write(packet.get());
	}

	void write(ConstBuffer buffer)
	{
		logDev(">>> %s", buffer);
		_socket.send(buffer);
	}

	void reply(Socket client, Buffer data)
	{
		data = VarInt(data.length.to!int) ~ data;

		logDev("Writing %s", data);
		client.send(VarInt(data.length.to!int).get ~ data);
	}

	void dispatchPacket(Packet packet)
	{
		import mined.handlers.handshake;
		import mined.handlers.loginstart;
		import mined.handlers.status;
		import mined.handlers.ping;
		import mined.handlers.dummy;
		import mined.handlers.handshake;
		import mined.handlers.plugin_message;
		import mined.handlers.client_settings;
		import mined.handlers.keepalive;

		import std.bitmanip : read;

		alias HandlerType = GameState delegate(Packet, Client);

		enum handlers =
		[
			GameState.HANDSHAKING: [
				0x00: &handleHandshake,
			],
			GameState.STATUS: [
				0x00: &handleStatus,
				0x01: &handlePing,
			],
			GameState.LOGIN: [
				0x00: &handleLoginstart,
			],
			GameState.PLAY: [
				0x04: &handleClientSettings,
				0x09: &handlePluginMessage,
				0x0B: &handleKeepalive,
			]
		];

		auto state = _state in handlers;
		if (state == null)
			return logError("No state %s found in handlers", _state);

		auto handler = packet.type in handlers[_state];
		if (handler == null)
			return logError("No handler for state: %s, packetType: %d", _state, packet.type);

		logDev("Got handler for state %s, packet %d", _state, packet.type);
		_state = (*handler)(packet, this);

		logDev("State switched to %s", _state);
	}

	void close()
	{
		_socket.shutdown(SocketShutdown.BOTH);
		_socket.close();
	}
}

struct ClientSettings
{
	string locale;
	byte viewDistance;
	int chatMode;
	bool chatColours;
	ubyte skinMask;
	int mainHand;
}
