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

void printBuffer(T)(T buf, string fun = __FUNCTION__, int line = __LINE__)
{
	logDevS("\x1b[31m%s\x1B[0m:\x1b[35m%d\x1B[0m: Buffer is (%d): ", fun, line, buf.length);
	foreach (i; 0 .. buf.length)
		std.stdio.writef("0x%x ", buf[i]);
	std.stdio.writeln();
}
