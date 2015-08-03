-module(exercise).
-compile(export_all).

% Exercises from chapter 3

sum(N) when N > 0 -> sum_acc(N, 0).
sum_acc(0, Acc) -> Acc;
sum_acc(N, Acc) -> sum_acc(N - 1, Acc + N).

sum(N, M) when N =< M -> sum_acc(N, M, 0).
sum_acc(N, M, Acc) when N > M -> Acc;
sum_acc(N, M, Acc) -> sum_acc(N + 1, M, Acc + N).

create(N) when N > 0 -> create_acc(N, []).
create_acc(0, L) -> L;
create_acc(N, L) -> create_acc(N-1, [N|L]).

reverse_create(N) when N > 0 -> reverse_create_list(N).
reverse_create_list(1) -> [1];
reverse_create_list(N) -> [N|reverse_create_list(N-1)].

print_int(N) when N > 0 -> print_int(1, N).
print_int(N, N) -> io:format("Number: ~p~n", [N]);
print_int(S, N) -> io:format("Number: ~p~n", [S]), print_int(S+1, N).

print_even_int(N) when N > 0 -> print_even_int(1, N).
% first solution
%print_even_int(N, N) -> ok;
%print_even_int(S, N) when S rem 2 == 0 ->
%  io:format("Number: ~p~n", [S]), print_even_int(S+1, N);
%print_even_int(S, N) -> print_even_int(S+1, N).

% second solution
print_even_int(S, N) ->
  if
    S == N -> ok;
    S rem 2 == 0 -> io:format("Number: ~p~n", [S]), print_even_int(S+1, N);
    true -> print_even_int(S+1, N)
end.

%%%% Manipulating lists
%  filter([1,2,3,4,5], 3) ⇒ [1,2,3]
filter(L, N) when is_list(L) -> filter_h(L, N).
filter_h([], _N) -> [];
filter_h([H|T], N) ->
  case N == H of
    true -> [H];
    false -> [H|filter_h(T, N)]
  end.

% reverse([1,2,3]) ⇒ [3,2,1]
reverse(L) when is_list(L) -> reverse_acc(L, []).
reverse_acc([], Acc) -> Acc;
reverse_acc([H|T], Acc) -> reverse_acc(T, [H|Acc]).

% concatenate([[1,2,3], [], [4, five]]) ⇒ [1,2,3,4,five]
concatenate(L) -> reverse(concatenate_acc(L, [])).
concatenate_acc([H|T], Acc) -> concatenate_acc(T, list_stack(Acc, H));
concatenate_acc([],Acc) -> Acc.

list_stack(Storage, [H|T]) ->
  list_stack([H|Storage], T);
list_stack(Storage, []) -> Storage.

%flatten([[1,[2,[3],[]]], [[[4]]], [5,6]]) ⇒ [1,2,3,4,5,6].
flatten(L) -> reverse(flatten_acc(L, [])).
flatten_acc([H|T], Acc) ->
  case is_list(H) of
    true -> flatten_acc(T, flatten_acc(H, Acc));
    false -> flatten_acc(T, [H|Acc])
  end;
flatten_acc([], Acc) -> Acc.

% 3-6 Sorting list
% Quicksort

%quicksort(L) -> quicksort(L, [], []).
%quicksort([Pivot|_] = L, Left, Right) -> quicksort_divide(Pivot, L, Left, Right)
%quicksort_divide(Pivot, [H|T], Left, Right) ->
%  case H < Pivot of
%    true ->
% TODO - finish quicksort


% Mergesort
mergesort(L) -> mergesort_divide(L, [], []).
mergesort_divide([H | [HT|T]], Left, Right) -> mergesort_divide(T, [H|Left], [HT|Right]);
mergesort_divide([H | T], Left, Right) ->
  case T == [] of
    true -> mergesort_divide(T, [H|Left], Right);
    false -> mergesort_divide(T, [H|Left], [T|Right])
  end;
mergesort_divide([], Left, []) -> Left;
mergesort_divide([], [], Right) -> Right;
mergesort_divide([], Left, Right) ->
  %io:format("~p ~p~n",[Left,Right]),
  mergesort_split(mergesort_divide(Left, [], []), mergesort_divide(Right, [], [])).

mergesort_split([], Right) -> Right;
mergesort_split(Left, []) -> Left;
mergesort_split([HL|TL] = Left, [HR|TR] = Right) ->
  case HL < HR of
    true -> [HL | mergesort_split(TL, Right)];
    false -> [HR | mergesort_split(Left, TR)]
  end.


% 3-7 Using library modules - DB v2
db_new() -> [].
db_destroy() -> ok.
db_write(Key, Element, Db) -> lists:append(Db, [{Key, Element}]).
db_delete(Key, Db) -> lists:keydelete(Key, 1, Db).
db_read(Key,Db) ->
  case lists:keyfind(Key,1,Db) of
    {_Key, Element} -> {ok, Element};
    false -> {error, instance}
  end.
db_match(Element, Db) -> [K || {K, E} <- Db, E == Element].


% 3-8 Evaluating and compiling expresions
%parse(E) -> parse_start(E, {})
%parse_start(E, Acc) -> parse_ob(E, Acc).
%parse_ob([H|T], Acc) ->
%  case H of
%    "(" -> parse_ob(T, Acc).
% TODO

% 3-9 Indexing
indexing(Filename) ->
  Raw = indexing_rawdoc(Filename),
  Words = indexing_words(Raw),
  L = indexing_line_occurence(Raw, Words),
  indexing_printpretty(L).

% print pretty "name"  1-2,3,6-8
indexing_printpretty([]) -> ok;
indexing_printpretty([{Word, List} |T] = _List) ->
  io:format("~p ", [Word]),
  indexing_printpretty_single(List, 0, false),
  io:format("~n"),
  indexing_printpretty(T).

indexing_printpretty_single([], PrevLine, PrevLinePrinted) ->
  case PrevLinePrinted of
    true -> ok;
    false -> true, io:format("-~p,",[PrevLine])
  end;

indexing_printpretty_single([H|T] = _List, PrevLine, PrevLinePrinted) ->
  if
    PrevLine == 0 -> PL = H, PLP = true, io:format("~p",[H]);
    PrevLine + 1 =/= H ->
      case PrevLinePrinted of
        true -> PL = H, PLP = true, io:format(",~p,",[H]);
        false -> PL = H, PLP = true, io:format("-~p,",[H])
      end;
    PrevLine + 1 == H -> PL = H, PLP = false
  end,
  %io:format("[dbg:~p:~p:~p]",[H,PrevLine,PL]),
  indexing_printpretty_single(T, PL, PLP).


indexing_rawdoc(Filename) ->
  {ok, Device} = indexing_openfile(Filename),
  L = indexing_read_file(Device, []),
  indexing_closefile(Device),
  L.
indexing_openfile(Filename) -> file:open(Filename, [read]).
indexing_closefile(Device) -> file:close(Device).
indexing_read_file(Device, Content) ->
  case io:get_line(Device, "") of
    eof -> lists:reverse(Content);
    Data -> indexing_read_file(Device, [Data|Content])
  end.

% Transform list of lines to list of words.
indexing_doc([]) -> [];
indexing_doc([H|T] = _Rawdoc) -> string:tokens(H, " ") ++ indexing_doc(T).

% List of words with only unique words
indexing_words(Rawdoc) -> indexing_words_acc(Rawdoc, []).
indexing_words_acc([], Acc) -> sets:to_list(sets:from_list(Acc));
indexing_words_acc([H|T] = _Rawdoc, Acc) ->
  indexing_words_acc(T, string:tokens(H, " ") ++ Acc).

indexing_line_occurence(Rawdoc, Words) -> indexing_line_occurence(Rawdoc, Words, []).
indexing_line_occurence(_Rawdoc, [] = _Words, Acc) -> Acc;
indexing_line_occurence(Rawdoc, [H|T] =_Words, Acc) ->
  indexing_line_occurence(Rawdoc, T,
    [{H,indexing_line_occurence_w(H, Rawdoc, [], 1)}|Acc]
  ).

% word occurence
indexing_line_occurence_w(_W, [], Acc, _Line) -> lists:reverse(Acc);
indexing_line_occurence_w(W, [H|T] = _Rawdoc, Acc, Line) ->
case string:str(H,W) of
  0 -> indexing_line_occurence_w(W, T, Acc, Line + 1);
  _ -> indexing_line_occurence_w(W, T, [Line|Acc], Line + 1)
end.

% 3-10 Text processing
% TODO
