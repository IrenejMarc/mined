module mined.handlers.ping;

import mined.client;
import mined.util.buffer;
import mined.gamestate;
import mined.packet;

struct PingHandler
{
	private Client _client;
	
	this(Client client)
	{
		_client = client;
	}

	GameState handle(Buffer buffer)
	{
		Packet response;
		response.type = 0x01;
		response.data = buffer;
		response.updateLength();

		_client.write(response);

		return GameState.STATUS;
	}
}
