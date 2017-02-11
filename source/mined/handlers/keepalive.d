module mined.handlers.keepalive;

import mined.gamestate;
import mined.client;
import mined.packet;

GameState handleKeepalive(Packet packet, Client client)
{
	Packet keepalive;
	keepalive.type = 0x1F;
	keepalive.data = packet.data;
	keepalive.updateLength();

	client.write(keepalive);

	return client.state;
}
