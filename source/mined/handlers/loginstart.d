module mined.handlers.loginstart;

import mined.client;
import mined.util.buffer;
import mined.gamestate;
import mined.util.logging;

struct LoginStartHandler
{
	private Client _client;
	
	this(Client client)
	{
		_client = client;
	}

	GameState handle(Buffer buffer)
	{
		logDev("Handling LoginStart!");
		return GameState.HANDSHAKING;
	}
}
