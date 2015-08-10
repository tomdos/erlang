%%% 10-1 DB server (main code is from chapter 5)

-module(my_db).
%-export([start/0, stop/0, write/2, delete/1, read/1, match/1, dbg/0, writelist/1]).
-compile(export_all).


% OTP interface
init(_Args) -> {ok, []}.
terminate(_Reason, _LoopData) -> ok.


% DB interface
%% start() -> register(exercise_db, spawn(exercise_db, loop, [[]])), ok.
%% dbg() -> exercise_db ! {dbg}, ok.
%% stop() -> exercise_db ! {stop}, ok.
%%
%% write(Key, Element) -> exercise_db ! {write, Key, Element}, ok.
%% delete(Key) -> exercise_db ! {delete, Key}, ok.
%% read(Key) -> exercise_db ! {read, Key, self()}, read_response().
%% match(Element) -> exercise_db ! {match, Element, self()}, match_response().
%% writelist([]) -> ok;
%% writelist([{Key,Element}|Tail] = _List) -> write(Key, Element), writelist(Tail).
%%
%%
%% read_response() ->
%%   receive
%%     {A, B} -> {A, B}
%%   end.
%%
%% match_response() ->
%%   receive
%%     Keys -> Keys
%%   end.

%%
%% loop(DB) ->
%%   receive
%%     {write, Key, Element} -> loop(db_write(Key, Element, DB));
%%     {delete, Key} -> loop(db_delete(Key, DB));
%%     {read, Key, Pid} -> Pid ! db_read(Key, DB), loop(DB);
%%     {match, Element, Pid} -> Pid ! db_match(Element, DB), loop(DB);
%%     {stop} -> ok;
%%     {dbg} -> dbg(DB), loop(DB)
%%   end.


dbg(Db) -> io:format("~p~n", [Db]).

% DB interface from chapter 3 (db.erl)
db_new() -> [].
db_destroy(_) -> ok.
db_write(Key, Element, Db) ->
  case is_list(Db) of
    true -> [{Key, Element} | Db];
    false -> {error, instance}
  end.

db_delete(Key, Db) when is_list(Db) -> db_delete_key(Key, Db, []).
db_delete_key(_Key, [], NewDb) -> NewDb;
db_delete_key(Key, [{K,_} = H|T], NewDb) ->
  case Key == K of
    true -> db_delete_key(Key, T, NewDb);
    false -> db_delete_key(Key, T, [H | NewDb])
  end.

db_read(Key, Db) when is_list(Db) -> db_read_key(Key, Db).
db_read_key(_Key, []) -> {error, instance};
db_read_key(Key, [{K,_} = H|T]) ->
  case Key == K of
    true -> H;
    false -> db_read_key(Key, T)
  end.

db_match(Element, Db) when is_list(Db) -> db_match_element(Element, Db, []).
db_match_element(_Element, [], Dacc) -> Dacc;
db_match_element(Element, [{K,E}|T], Dacc) ->
  case Element == E of
    true -> db_match_element(Element, T, [K|Dacc]);
    false -> db_match_element(Element, T, Dacc)
  end.
