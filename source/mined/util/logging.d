///
module mined.util.logging;

import std.stdio;

void logDebug(T...)(string format, T data)
{
	writefln("\x1B[36m[DEBUG]\x1B[0m -- " ~ format, data);
}

void logDevS(T...)(string format, T data)
{
	writef("\x1B[96m[DEV]\x1B[0m " ~ format, data);
}

void logDev(T...)(string format, T args)
{
	logDevS(format, args);
	writeln();
}
