///
module mined.types.string;

import mined.types.varint;
import mined.util.buffer;

struct String
{
	static string read(ref Buffer buf)
	{
		int length = VarInt.read(buf).value;
		string str = cast(string) buf[0 .. length];
		buf = buf[0 .. length];

		return str;
	}
}
