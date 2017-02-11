module mined.handlers.ping;

import mined.client;
import mined.util.buffer;
import mined.gamestate;
import mined.packet;
import mined.util.logging;

GameState handlePing(Packet packet, Client client)
{
		logDev("Handling Ping packet");

		Packet response;
		response.type = 0x01;
		response.data = packet.data;
		response.updateLength();

		client.write(response);

		return GameState.HANDSHAKING;
}
