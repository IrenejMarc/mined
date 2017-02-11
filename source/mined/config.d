module mined.config;

import std.conv : to;

import sdlang;

private struct BindConfig
{
	short port = 25565;
	string address = "0.0.0.0";
}

struct Config
{
	string motd;
	int maxPlayers;
	BindConfig bind;

	static Config read(string filename = "config.sdl")
	{
		Config config;

		auto root = parseFile(filename);
		config.motd = root.getTagValue!string("motd");
		config.maxPlayers = root.getTagValue!int("max-players");
		
		config.bind.port = root.getTagAttribute!int("bind", "port").to!short;
		config.bind.address = root.getTagAttribute!string("bind", "address");

		return config;
	}
}

