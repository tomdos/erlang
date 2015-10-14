REBAR=rebar

# workaround for a rebar bug
unexport ERL_LIBS

all: 
	$(REBAR) compile
	
deps:
	$(REBAR) get-deps

server: 
	$(REBAR) compile

clean:
	$(REBAR) clean
