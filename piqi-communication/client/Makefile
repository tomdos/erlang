CC=g++
CFLAGS=-I../ `pkg-config --cflags --libs protobuf`
CLIENT=client

#all:
#    cd ..; rebar compile skip_deps=true

client: client.cpp
	$(CC) $(CFLAGS) client.cpp ../proto/message.piqi.pb.cc -o $(CLIENT)

clean:
	rm -f client
