%%%% 10-1 Database server revisited - OTP
-module(my_db_gen).
-export([start/0, stop/0]).
-export([init/1, terminate/2, handle_call/3, handle_cast/2]).
-export([write/2, delete/1, read/1, match/1, dbg/0, die/0]).
-behaviour(gen_server).

% Starting and stopping the server - server commands
start() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
  gen_server:cast(?MODULE, {stop}).

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

die() ->
  gen_server:cast(?MODULE, {die}).


% OTP interface and callbacks to DB
init(_Args) ->
  NewDB = my_db:db_new(),
  {ok, NewDB}.

terminate(_Reason, DB) ->
  my_db:db_destroy(DB),
  ok.

handle_cast({stop}, DB) -> {stop, normal, DB};
handle_cast({die}, DB) -> exit(kill), {noreply, DB}.

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