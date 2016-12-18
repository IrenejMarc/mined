module mined.handlers.loginstart;

import mined.client;
import mined.util.buffer;
import mined.gamestate;
import mined.util.logging;
import mined.types.string;
import mined.types.varint;

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
		string username = String.read(buffer);

		logDev("Login username: %s", username);
		return GameState.HANDSHAKING;
	}
}
