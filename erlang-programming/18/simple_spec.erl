-module(simple_spec).
-compile(export_all).


-spec(test_print(A::atom(), L::list(), T::tuple()) -> {{atom(), list(), tuple()}}).

test_print(A, L, T) when is_atom(A), is_list(L), is_tuple(T) ->
  io:format("Print input atom: ~p, list:~p and tuple: ~p.~n", [A,L,T]),
  {A,L,T}.
