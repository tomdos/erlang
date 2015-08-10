%%%% 12-1 Database server revisited - OTP
-module(my_db_gen).
-export([start/0, stop/0]).
-export([write/2]).
-behaviour(gen_server).
-compile(export_all).

% Starting and stopping the server
start() ->
  gen_server:start({local, ?MODULE}, my_db, [], []).

stop() ->
  gen_server:stop(?MODULE, stop).


% Public server API

write(Key, Element) ->
  gen_server:call(?MODULE, {Key, Element}).

dbg() ->
  gen_server:call(?MODULE, {}).

%% dbg() -> exercise_db ! {dbg}, ok.

%%
%% write(Key, Element) -> exercise_db ! {write, Key, Element}, ok.
%% delete(Key) -> exercise_db ! {delete, Key}, ok.
%% read(Key) -> exercise_db ! {read, Key, self()}, read_response().
%% match(Element) -> exercise_db ! {match, Element, self()}, match_response().
%% writelist([]) -> ok;
%% writelist([{Key,Element}|Tail] = _List) -> write(Key, Element), writelist(Tail).

% Internal wrappers of DB server

% OTP callbacks of DB
handle_write({Key, Element}, _From, DB) ->
  NewDB = my_db:write(Key, Element, DB),
  {reply, ok, NewDB}.

handle_dbg(_Args, _From, DB) ->
  my_db:dbg(DB),
  {reply, DB, DB}.