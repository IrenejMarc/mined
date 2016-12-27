///
module mined.types.string;

import std.string : representation;

import mined.types.varint;
import mined.util.buffer;

struct String
{
	private string _string;
	
	alias get this;

	this(string str)
	{
		this._string = str;
	}

	@property get()
	{
		return VarInt(_string.representation.length.to!int) ~ _string.representation;
	}

	static string read(ref Buffer buf)
	{
		int length = VarInt.read(buf).value;
		string str = cast(string) buf[0 .. length];
		buf = buf[0 .. length];

		return str;
	}
}
