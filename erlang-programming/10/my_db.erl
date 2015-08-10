%%% 10-1 DB server (main code is from chapter 5)

-module(my_db).
%-export([start/0, stop/0, write/2, delete/1, read/1, match/1, dbg/0, writelist/1]).
-compile(export_all).


db_new() -> [].
db_destroy(_) -> ok.
db_dbg(Db) -> io:format("DB debug: ~p~n", [Db]).

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
