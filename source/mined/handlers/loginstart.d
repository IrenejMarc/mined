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

	string uuid = "dffddebf-6aef-4767-9202-d17a6769b5aa";
	Packet loginSuccess;
	loginSuccess.type = 0x02;
	loginSuccess.data ~= String(uuid);
	loginSuccess.data ~= String(username);
	loginSuccess.updateLength();

	client.write(loginSuccess);

	writeJoinGame(client);

	/*
	// Working disconnect
	Packet disconnect;
	disconnect.type = 0x00;
	JSONValue chat = JSONValue(["text": "Disconnect because why not"]);
	disconnect.data = String(chat.toString);
	disconnect.updateLength();
	client.write(disconnect);
	*/

	return GameState.PLAY;
}

void writeJoinGame(Client client)
{
	import std.bitmanip : append;
	import std.array : appender;

	Packet packet;
	packet.type = 0x23;

	auto buffer = appender!(ubyte[]);

	logDev("Writing entity ID");
	buffer.append!int(1); // Entity ID
	logDev("Writing Gamemode");
	buffer.append!ubyte(0); // Gamemode (0 - Survival)
	buffer.append!int(0); // Dimension (0 - overworld)
	buffer.append!ubyte(0); // Difficulty (0 - peaceful)
	buffer.append!ubyte(0); // max players - ignored
	buffer ~= String("flat"); // World type
	buffer.append!bool(false);

	packet.data = buffer.data;
	packet.updateLength();

	client.write(packet);
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
