// Handles the serverbound packet 0x00, AKA handshake start
module mined.handlers.handshake;

import std.bitmanip : read;

import mined.util.buffer;
import mined.util.logging;
import mined.client;
import mined.types.varint;
import mined.gamestate;
import mined.packet;
import mined.types.string;

GameState handleHandshake(Packet packet, Client client)
{
	uint protocolVersion = VarInt.read(packet.data).value;
	string hostname = String.read(packet.data);
	ushort port = packet.data.read!ushort;
	int nextState = VarInt.read(packet.data).value;

	logDev("Protocol: %d, hostname: %s, port: %d, nextState: %d", protocolVersion, hostname, port, nextState);

	return cast(GameState) nextState;
}
