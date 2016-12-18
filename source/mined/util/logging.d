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

void printBuffer(T)(T buf, string fun = __FUNCTION__, int line = __LINE__)
{
	logDev("\x1b[31m%s\x1B[0m:\x1b[35m%d\x1B[0m: Buffer is (%d): %s", fun, line, buf.length, buf);
}
