-module(db).
%-export([new/0]).
-compile(export_all).

% simple db (list) with new, destroy, write, delete, read, match interfaces.

new() -> [].
destroy(_) -> ok.
write(Key, Element, Db) ->
  case is_list(Db) of
    true -> [{Key, Element} | Db];
    false -> {error, instance}
  end.

delete(Key, Db) when is_list(Db) -> delete_key(Key, Db, []).
delete_key(_Key, [], NewDb) -> NewDb;
delete_key(Key, [{K,_} = H|T], NewDb) ->
 case Key == K of
   true -> delete_key(Key, T, NewDb);
   false -> delete_key(Key, T, [H | NewDb])
 end.

read(Key, Db) when is_list(Db) -> read_key(Key, Db).
read_key(_Key, []) -> {error, instance};
read_key(Key, [{K,_} = H|T]) ->
  case Key == K of
    true -> H;
    false -> read_key(Key, T)
  end.

match(Element, Db) when is_list(Db) -> match_element(Element, Db, []).
match_element(_Element, [], Dacc) -> Dacc;
match_element(Element, [{K,E}|T], Dacc) ->
  case Element == E of
    true -> match_element(Element, T, [K|Dacc]);
    false -> match_element(Element, T, Dacc)
  end.
