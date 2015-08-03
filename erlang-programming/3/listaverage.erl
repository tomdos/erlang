-module(listaverage).
-export([average/1]).

average(L) -> sum(L) / len(L).

sum([]) -> 0;
sum([H|T]) -> H + sum(T).

len([]) -> 0;
len([_|T]) -> 1 + len(T).
