module mined.handlers.loginstart;

import std.conv : to;
import std.json;

import mined.client;
import mined.util.buffer;
import mined.gamestate;
import mined.util.logging;
import mined.types.string;
import mined.types.varint;
import mined.packet;

GameState handleLoginstart(Packet packet, Client client)
{
	logDev("Handling LoginStart!");
	string username = String.read(packet.data);

	logDev("Login username: %s", username);

	Packet loginSuccess;
	loginSuccess.type = 0x02;
	loginSuccess.data ~= String("dffddebf-6aef-4767-9202-d17a6769b5aa");
	loginSuccess.data ~= String(username);
	loginSuccess.updateLength();
	client.write(loginSuccess);

	//Packet encryptionRequest = createEncryptionRequest();
	//client.write(encryptionRequest);

	/*
	// Working disconnect
	Packet disconnect;
	disconnect.type = 0x00;
	JSONValue chat = JSONValue(["text": "Disconnect because why not"]);
	disconnect.data = String(chat.toString);
	disconnect.updateLength();
	client.write(disconnect);
	*/

	return GameState.LOGIN;
}

Packet createEncryptionRequest()
{
	Packet encryptionRequest;

	string serverId;
	ubyte[] pubkey = [1, 2, 3];
	ubyte[] verifyToken = [1, 2, 3, 4];

	Buffer data;
	data ~= String(serverId);
	data ~= VarInt(pubkey.length.to!int);
	data ~= pubkey;

	data ~= VarInt(verifyToken.length.to!int);
	data ~= verifyToken;

	return Packet(0x01, data);
}
