import std.socket;
import std.conv : to;
import std.bitmanip;
import std.string;
import std.array;
static import std.stdio;

import mined.client;
import mined.server;
import mined.util.buffer;
import mined.handlers.handshake;
import mined.util.logging;


void main()
{
	Server server = new Server;
	server.bind();
	server.run();
}

