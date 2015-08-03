-module(listsum).
-export([listsum/1]).

listsum([]) -> 0;
listsum([H|T]) -> H + listsum(T).
