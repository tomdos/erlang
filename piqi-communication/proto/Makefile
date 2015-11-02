all:
	cd ..; rebar compile skip_deps=true

PIQIC = $(REBAR_DEPS_DIR)/piqi/priv/bin/piqic-erlang
PIQI_FILES = message.piqi
SRC = ../src/

PIQI_ERL_FILES = $(PIQI_FILES:%.piqi=%_piqi.erl)
PIQI_HRL_FILES = $(PIQI_FILES:%.piqi=%_piqi.hrl)

piqi: $(PIQI_FILES)
	$(PIQIC) $^
	
piqi_proto: $(PIQI_FILES)
	piqi to-proto $^
	mv $(PIQI_ERL_FILES) ../src
	mv $(PIQI_HRL_FILES) ../src
			
protoc: piqi_proto
	protoc --cpp_out=. -I. message.piqi.proto

clean: piqi-clean protoc-clean
	
protoc-clean:
	rm -f message.piqi.proto
	rm -f message.piqi.pb.cc
	rm -f message.piqi.pb.h

piqi-clean:
	rm -f $(SRC)/$(PIQI_ERL_FILES)
	rm -f $(SRC)/$(PIQI_HRL_FILES)
