-module(exercise).
-compile(export_all).

%%%% 9-1 Higher-ordered functions
print_seq(N) ->
  print_list(lists:seq(1,N)).

print_list(L) ->
  Printer = fun(Number) -> io:format("~p~n", [Number]) end,
  lists:foreach(Printer, L).

print_smaller(List, Max) ->
  Filter = fun(Number) -> (Number < Max) end,
  Res = lists:filter(Filter, List),
  print_list(Res).

print_even(N) ->
  L = [X || X <- lists:seq(1,N), X rem 2 == 0],
  print_list(L).


print_sum(List) ->
  Fun = fun(N, Acc) -> N + Acc end,
  Sum = lists:foldl(Fun, 0, List),
  io:format("~p~n", [Sum]).

%%%% 9-2 List comprehensions
com_three(N) ->
  [X || X <- lists:seq(1,N), X rem 3 == 0].

com_three2(N) -> com_three2(3, N).
com_three2(I, Max) when (I =< Max) -> [I|com_three2(I+3, Max)];
com_three2(_I, _Max) -> [].

com_filter_int(List) ->
  [X || X <- List, is_integer(X)].

com_intersection(A, B) ->
  [X || X <- A, Y <- B, X == Y].

% non comprehension solution
com_symdiff(A, B) ->
 com_symdiff_part(A,B) ++ com_symdiff_part(B,A).

com_symdiff_part([], _B) -> [];
com_symdiff_part([H|T] = _A, B) ->
  Fun = fun(Item) -> H =/= Item end,
  case lists:all(Fun, B) of
    true -> [H|com_symdiff_part(T,B)];
    false -> com_symdiff_part(T,B)
  end.

% slution by comprehension
com_symdiff2(A,B) ->
  com_symdiff2_part(A,B) ++ com_symdiff2_part(B,A).

com_symdiff2_part(A,B) ->
  [X || X <- A, lists:all(fun(Item) -> X =/= Item end, B)].


%%%% 9-3 Zip functions

