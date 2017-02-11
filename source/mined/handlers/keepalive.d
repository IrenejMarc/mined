module mined.handlers.keepalive;

import mined.gamestate;
import mined.client;
import mined.packet;

GameState handleKeepalive(Packet packet, Client client)
{
	client.write(packet);

	return client.state;
}
