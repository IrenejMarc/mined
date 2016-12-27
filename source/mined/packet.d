module mined.packet;

import mined.util.buffer;
import mined.types.varint;
import mined.util.logging;

struct Packet
{
	int length;
	int type;
	Buffer data;

	alias get this;

	this(int type, ConstBuffer data)
	{
		this.type = type;
		this.data = data.dup;

		VarInt packetType = VarInt(type);

		this.length = packetType.length;
	}

	@property ConstBuffer get()
	{
		return VarInt(length) ~ VarInt(type) ~ data;
	}

	static bool tryRead(ref Buffer buffer, ref Packet packet)
	{
		if (buffer.length == 0)
			return false;

		int nRead;
		int packetLength = VarInt.peek(buffer, nRead).value;

		if (nRead == 0 || packetLength > buffer.length)
			return false;

		buffer = buffer[nRead .. $];

		packet.length = packetLength;

		VarInt type = VarInt.read(buffer);
		packet.type = type.value;
		packet.data = buffer[0 .. packetLength - type.length].dup;

		buffer = buffer[packetLength - type.length .. $];

		return true;
	}
}
