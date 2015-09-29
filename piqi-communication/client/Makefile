CC=g++
CFLAGS=-I../ `pkg-config --cflags --libs protobuf`
CLIENT=client

all: client

piqi_proto: ../proto/message.piqi
	piqi to-proto $^
		
protoc: piqi_proto
	protoc --cpp_out=../proto -I../proto ../proto/message.piqi.proto

client: client.cpp protoc
	$(CC) $(CFLAGS) client.cpp ../proto/message.piqi.pb.cc -o $(CLIENT)

clean:
	rm -f client
	rm -f ../proto/message.piqi.proto
	rm -f ../proto/message.piqi.pb.cc
	rm -f ../proto/message.piqi.pb.h

