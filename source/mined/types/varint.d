///
module mined.types.varint;

import std.bitmanip;
import std.string : format;

import mined.util.buffer;
import mined.util.logging;

enum END_MASK = 0b1000_0000;
enum VALUE_MASK = ~END_MASK;
enum MAX_VARINT_LENGTH = 5;

/// Represents the Minecraft VarInt type, provides conversions
struct VarInt
{
	private Buffer _representation;
	alias get this;

	this(int value)
	{
		opAssign(value);
	}

	this(Buffer value)
	{
		opAssign(value);
	}

	@property int value()
	{
		return VarInt._toInt(_representation);
	}

	@property ConstBuffer get()
	{
		return _representation.dup;
	}

	// Reads a VarInt from the given buffer
	void opAssign(Buffer varInt)
	{
		assert(varInt.length <= MAX_VARINT_LENGTH,
				"VarInt opAssign can only be used with actual VarInt representations, "~
				"do not use it with buffers");
		_representation = varInt;
	}

	// Converts the VarInt to the proper format, returns a Buffer
	void opAssign(int value)
	{
		Buffer buf;
		do
		{
			byte temp = cast(byte) (value & VALUE_MASK);

			value >>>= 7;

			if (value != 0) 
				temp |= 0b10000000;
			buf ~= temp;

		}
		while (value != 0);

		_representation = buf;
	}

	static VarInt peek(Buffer buffer)
	{
		Buffer buf;

		ubyte read = 0;
		int nRead = 0;

		do
		{
			read = buffer.read!ubyte;
			buf ~= read;
		} while((read & END_MASK) != 0 && ++nRead <= MAX_VARINT_LENGTH);

		return VarInt(buf);
	}

	static VarInt read(ref Buffer buffer)
	{
		Buffer buf;

		ubyte read = 0;
		int nRead = 0;

		do
		{
			read = buffer.read!ubyte;
			buf ~= read;
		} while((read & END_MASK) != 0 && ++nRead <= MAX_VARINT_LENGTH);

		return VarInt(buf);
	}

	private static int _toInt(Buffer representation)
	{
		int result = 0;
		int numRead = 0;
		ubyte read = 0;

		do
		{
			read = cast(ubyte) representation.read!ubyte;

			int value = read & VALUE_MASK;

			result |= (value << (7 * numRead++));
			
			if (numRead > MAX_VARINT_LENGTH)
				throw new VarIntTooBigException(
						"Error reading VarInt: too long (%s)".format(representation)
				);
		} 
		while((read & END_MASK) != 0);

		return result;
	}
}

class VarIntTooBigException : Exception
{
	this(const string msg)
	{
		super(msg);
	}
}
