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
	logDev("Packet data: %s", packet.data);
	uint protocolVersion = VarInt.read(packet.data).value;
	logDev("	* Remaining buffer: %s", packet.data);
	string hostname = String.read(packet.data);
	logDev("	* Read hostname: %s, Remaining buffer: %s", hostname, packet.data);
	ushort port = packet.data.read!ushort;
	logDev("	* Read port: %d, Remaining buffer: %s", port, packet.data);
	int nextState = VarInt.read(packet.data).value;
	logDev("	* Remaining buffer: %s", packet.data);

	logDev("Protocol: %d, hostname: %s, port: %d, nextState: %d", protocolVersion, hostname, port, nextState);

	return cast(GameState) nextState;
}
