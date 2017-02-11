module mined.handlers.client_settings;

import std.bitmanip : read;

import mined.client;
import mined.gamestate;
import mined.packet;
import mined.types.string;
import mined.types.varint;
import mined.util.logging;

GameState handleClientSettings(Packet packet, Client client)
{
	logDev("Handling clientSettings");
	string locale = String.read(packet.data);
	byte viewDistance = packet.data.read!byte;
	int chatMode = VarInt.read(packet.data).value;
	bool chatColours = packet.data.read!bool;
	ubyte skinMask = packet.data.read!ubyte;
	int mainHand = VarInt.read(packet.data).value;

	client.settings.locale = locale;
	client.settings.viewDistance = viewDistance;
	client.settings.chatMode = chatMode;
	client.settings.chatColours = chatColours;
	client.settings.skinMask = skinMask;
	client.settings.mainHand = mainHand;

	logDev("ClientSettings are %s", client.settings);
	
	return client.state;
}
