% 7-3 The db.erl exercise revisited - based on db example from chapter 3

-module(exercise_db).
-include("exercise_db.hrl").
-compile(export_all).

new() -> [].
destroy(_) -> ok.
print_all(Db) -> io:format("~p~n", [Db]).

write(Key, Element, Db) ->
  case is_list(Db) of
    true -> [#database{key=Key, data=Element} | Db];
    false -> {error, instance}
  end.

delete(Key, Db) when is_list(Db) -> delete_key(Key, Db, []).
delete_key(_Key, [], NewDb) -> NewDb;
delete_key(Key, [#database{key=K} = H|T], NewDb) ->
 case Key == K of
   true -> delete_key(Key, T, NewDb);
   false -> delete_key(Key, T, [H | NewDb])
 end.

read(Key, Db) when is_list(Db) -> read_key(Key, Db).
read_key(_Key, []) -> {error, instance};
read_key(Key, [#database{key=K,data=Element} = _H|T]) ->
  case Key == K of
    true -> Element;
    false -> read_key(Key, T)
  end.

match(Element, Db) when is_list(Db) -> match_element(Element, Db, []).
match_element(_Element, [], Dacc) -> Dacc;
match_element(Element, [#database{key=K, data=E}|T], Dacc) ->
  case Element == E of
    true -> match_element(Element, T, [K|Dacc]);
    false -> match_element(Element, T, Dacc)
  end.
