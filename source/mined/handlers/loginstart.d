module mined.handlers.loginstart;

import std.conv : to;

import mined.client;
import mined.util.buffer;
import mined.gamestate;
import mined.util.logging;
import mined.types.string;
import mined.types.varint;
import mined.packet;

struct LoginStartHandler
{
	private Client _client;
	
	this(Client client)
	{
		_client = client;
	}

	void sendEncryptionRequest()
	{
		Packet encryptionRequest;

		string serverId;
		ubyte[] pubkey;
		ubyte[] verifyToken;

		Buffer data;
		data ~= String(serverId);
		data ~= VarInt(pubkey.length.to!int);
		data ~= pubkey;

		data ~= VarInt(verifyToken.length.to!int);
		data ~= verifyToken;

		encryptionRequest = Packet(0x01, data);

		_client.write(encryptionRequest);
	}

	GameState handle(Buffer buffer)
	{
		logDev("Handling LoginStart!");
		string username = String.read(buffer);

		logDev("Login username: %s", username);

		sendEncryptionRequest();

		return GameState.LOGIN;
	}
}
