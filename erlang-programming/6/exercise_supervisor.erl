%% 6-3 A supervisor process

-module(exercise_supervisor).
-export([start_link/2, stop/1, start_filled/0, debug/0]).
-export([init/1]).

start_filled() -> start_link(exercise_supervisor, [
    {add_two, start, [], permanent},
    {add_two_transident, start, [], transident},
    {add_fail, start, [], permanent}
    %{non_exist_module, non_exist_fun, [], permanent}
  ]).

start_link(Name, ChildSpecList) ->
  register(Name, spawn_link(exercise_supervisor, init, [ChildSpecList])), ok.

init(ChildSpecList) -> process_flag(trap_exit, true), loop(start_children(ChildSpecList)).

start_children([]) -> [];

start_children([{M, F, A, T} | ChildSpecList]) ->
  case (catch apply(M,F,A)) of
    {ok, Pid} -> [{Pid, {M,F,A,T}}|start_children(ChildSpecList)];
    _ -> start_children(ChildSpecList)
  end.

restart_child(Pid, ChildList, StopReason) ->
  {value, {Pid, {M,F,A,T}}} = lists:keysearch(Pid, 1, ChildList),
  if
    (T == permanent) or ((T == transident) and (StopReason =/= normal)) ->
      {ok, NewPid} = apply(M,F,A),
      [{NewPid, {M,F,A,T}}|lists:keydelete(Pid,1,ChildList)];
    (T == transident) ->
      lists:keydelete(Pid,1,ChildList)
  end.

loop(ChildList) ->
  receive
    {'EXIT', Pid, Reason} ->
      io:format("Process ~p stopped, reason: ~p~n", [Pid, Reason]),
      NewChildList = restart_child(Pid, ChildList, Reason), loop(NewChildList);
    {stop, From} -> From ! {reply, terminate(ChildList)};
    {debug} -> io:format("DEBUG: ~p~n", [ChildList]), loop(ChildList)
  end.

stop(Name) ->
  Name ! {stop, self()},
  receive
    {reply, Reply} -> Reply
  end.

debug() ->
  exercise_supervisor ! {debug}.


terminate([{Pid, _} | ChildList]) -> exit(Pid, kill), terminate(ChildList);

terminate(_ChildList) -> ok.
