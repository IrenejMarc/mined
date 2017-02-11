module mined.handlers.plugin_message;

import mined.gamestate;
import mined.packet;
import mined.client;
import mined.util.logging;

GameState handlePluginMessage(Packet packet, Client client)
{
	logDev("Handling plugin message, ignoring");
	return client.state;
}
