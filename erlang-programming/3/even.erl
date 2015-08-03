-module(even).
-export([even/1]).

even([]) -> [];
even([H|T]) ->
  case H rem 2 of
    0 -> [H|even(T)];
    1 -> even(T)
  end.
