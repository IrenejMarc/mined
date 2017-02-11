module mined.packet;

import std.string : format;

import mined.util.buffer;
import mined.types.varint;
import mined.util.logging;

struct Packet
{
	int length;
	int type;
	Buffer data;

	alias get this;

	string toString()
	{
		return "<Packet -- Length: %d, Type: %d, Data: %s>".format(length, type, data);
	}

	this(int type, ConstBuffer data)
	{
		this.type = type;
		this.data = data.dup;

		VarInt packetType = VarInt(type);

		this.length = packetType.length;
	}

	static Packet read(ref Buffer buffer)
	{
		Packet packet;

		int nRead = 0;

		packet.length = VarInt.peek(buffer, nRead).value;
		packet.data = buffer[nRead .. packet.length + 1].dup;
		buffer = buffer[packet.data.length + 1 .. $];

		packet.type = VarInt.read(packet.data).value;

		return packet;
	}

	void updateLength()
	{
		length = (VarInt(type).length + data.length).to!int;
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
