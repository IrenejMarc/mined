///
module mined.server;

import std.socket;
import std.algorithm : remove;

import mined.client;
import mined.util.logging;
import mined.util.buffer;
import mined.types.varint;

class Server
{
	private
	{
		TcpSocket _serverSocket;
		Client[Socket] _clients;
	}


	this()
	{
		_serverSocket = new TcpSocket;
	}

	void bind()
	{
		ushort port = 25565;

		assert(_serverSocket.isAlive);

		_serverSocket.setOption(SocketOptionLevel.SOCKET, SocketOption.REUSEADDR, true);
		_serverSocket.blocking = false;

		_serverSocket.bind(new InternetAddress(port));
		_serverSocket.listen(1);

		logDebug("Listening on port %d", port);
	}

	void run()
	{
		int maxConnections = 64;

		SocketSet socketSet = new SocketSet(maxConnections + 1);
		Socket[] reads;

		Buffer partialPackets;

		while(true)
		{
			// Accept any incoming connections and add them to to socket set
			socketSet.add(_serverSocket);

			foreach (socket; reads)
				socketSet.add(socket);

			Socket.select(socketSet, null, null);

			for (uint i = 0; i < reads.length; ++i)
			{
				Buffer buf;
				buf.length = 2048;
				auto received = reads[i].receive(buf[]);

				if (received != 0)
				{
					logDev("Received %d bytes: %s", received, buf[0 .. received]);
					auto client = reads[i] in _clients;
					if (client is null)
						_clients[reads[i]] = new Client(this, reads[i]);

					int sent = 0;
					int packetLength = 0;
					// Respond to all received packets
					do
					{
						packetLength = VarInt.read(buf).value;
						logDev("Read length of packet: %d", packetLength);
						_clients[reads[i]].dispatchPacket(buf[0 .. packetLength], packetLength);
						sent = packetLength;
						buf = buf[sent .. $];

					}
					while (packetLength <= sent + received);


					continue;
				}
				else if (received == Socket.ERROR)
				{
					logDebug("Connection error.");
				}
				else
				{
					try
					{
						logDebug("Connection from %s closed.", reads[i].remoteAddress().toString());
					}
					catch (SocketException)
					{
						logDebug("Connection closed.");
					}
				}

				reads[i].close();
				reads = reads.remove(i);
				i -= 1;
			}


			acceptConnections(socketSet, _serverSocket, reads);

			socketSet.reset();
		}
	}

	private:

	// Accepts new incoming connections, adds them to the given reads array.
	void acceptConnections(SocketSet socketSet, Socket listener, ref Socket[] reads)
	{
		if (socketSet.isSet(listener))
		{
			Socket client;

			scope (failure)
			{
				logDebug("Error accepting.");

				if (client)
					client.close();
			}

			client = listener.accept();
			assert(listener.isAlive);
			assert(client.isAlive);

			if (reads.length < socketSet.max)
			{
				logDebug("Connection from %s established.", client.remoteAddress);
				reads ~= client;
			}
			else
			{
				logDebug("Connection rejected, too many connections.");
				client.close();
			}
		}
	}
}
