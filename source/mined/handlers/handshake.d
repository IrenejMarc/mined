// Handles the serverbound packet 0x00, AKA handshake start
module mined.handlers.handshake;

import std.bitmanip : read;

import mined.util.buffer;
import mined.util.logging;
import mined.client;
import mined.types.varint;
import mined.gamestate;

struct HandshakeHandler
{
	private Client _client;

	this(Client client)
	{
		_client = client;
	}

	GameState handle(Buffer buffer)
	{
		uint protocolVersion = VarInt.read(buffer).value;

		int hostLength = VarInt.read(buffer).value;

		string hostname = cast(string) buffer[0 .. hostLength];
		buffer = buffer[hostLength .. $];
		ushort port = buffer.read!ushort;
		int nextState = VarInt.read(buffer).value;

		logDev("Protocol: %d, hostname: %s, port: %d, nextState: %d", protocolVersion, hostname, port, nextState);

		return cast(GameState) nextState;
	}
}

