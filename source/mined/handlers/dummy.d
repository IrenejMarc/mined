module mined.handlers.dummy;

import mined.client;
import mined.gamestate;
import mined.packet;
import mined.util.logging;

GameState dummyHandler(Packet packet, Client client)
{
	logDev("Dummy handler for %d", packet.type);
	return client.state;
}
