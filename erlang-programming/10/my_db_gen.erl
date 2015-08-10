%%%% 10-1 Database server revisited - OTP
-module(my_db_gen).
-export([start/0, stop/0]).
-export([write/2]).
-behaviour(gen_server).
-compile(export_all).


% Starting and stopping the server - server commands
start() ->
  gen_server:start({local, ?MODULE}, ?MODULE, [], []).

stop() ->
  gen_server:cast(?MODULE, stop).


% Public server API
write(Key, Element) ->
  gen_server:call(?MODULE, {write, Key, Element}).

delete(Key) ->
  gen_server:call(?MODULE, {delete, Key}).

read(Key) ->
  gen_server:call(?MODULE, {read, Key}).

match(Element) ->
  gen_server:call(?MODULE, {match, Element}).

dbg() ->
  gen_server:call(?MODULE, {dbg}).


% OTP interface and callbacks to DB
init(_Args) -> {ok, []}.
terminate(_Reason, _DB) -> ok.

handle_cast(stop, DB) -> {stop, normal, DB}.

handle_call({write, Key, Element}, _From, DB) ->
  NewDB = my_db:db_write(Key, Element, DB),
  {reply, written, NewDB};

handle_call({delete, Key}, _From, DB) ->
  NewDB = my_db:db_delete(Key, DB),
  {reply, deleted, NewDB};

handle_call({read, Key}, _From, DB) ->
  Element = my_db:db_read(Key, DB),
  {reply, Element, DB};

handle_call({match, Element}, _From, DB) ->
  Keys = my_db:db_match(Element, DB),
  {reply, Keys, DB};

handle_call({dbg}, _From, DB) ->
  my_db:db_dbg(DB),
  {reply, DB, DB}.