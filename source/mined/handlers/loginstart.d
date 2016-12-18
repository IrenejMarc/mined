module mined.handlers.loginstart;

import mined.client;
import mined.util.buffer;
import mined.gamestate;

struct LoginStartHandler
{
	private Client _client;
	
	this(Client client)
	{
		_client = client;
	}

	GameState handle(Buffer buffer)
	{
		return GameState.HANDSHAKING;
	}
}
