module mined.handlers.status;

import mined.client;
import mined.gamestate;
import mined.packet;
import mined.util.buffer;
import mined.util.logging;
import mined.types.string;

import std.string;
import std.json;

GameState handleStatus(Packet packet, ref Client client)
{
		logDev("Handling status");

		Packet response;

		JSONValue responseJson = [
			"version": JSONValue([
				"name": JSONValue("1.11.2"),
				"protocol": JSONValue(316)
			]),
			"players": JSONValue([
				"max": JSONValue(64),
				"online": JSONValue(0),
				"sample": JSONValue(),
			]),
			"description": JSONValue([
				"text": JSONValue("Mined server")
			]),
			"favicon": JSONValue("data:image/png;base64,<data>")
		];

		logDev("JSON: %s", responseJson.toString);

		String JsonStr = String(responseJson.toString);
		response.type = 0x00;
		response.data = JsonStr;
		
		response.updateLength();
		logDev("Response length: %d, type: %d", response.length, response.type);

		client.write(response);

		return GameState.STATUS;
}
