%% 6-3 A supervisor process
% TODO - start duplicate child
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
    {ok, Pid} -> [{Pid, {M,F,A,T,{0,0,0},0}}|start_children(ChildSpecList)];
    _ -> start_children(ChildSpecList)
  end.

% Dummy test
-define(ONEMIN, 60).
update_child_restart_time({RTMega, RTSec, _RTMicro} = RT, RC) ->
  {NowMega, NowSec, _NowMicro} = Now = erlang:now(),
  if
    %((RTMega - NowMega) < 0) -> {Now, RC};
    ((NowMega - RTMega) == 1) -> NowBigSec = 1000000 + NowSec, % transform Now to sec
      if
        ((NowBigSec - RTSec) < ?ONEMIN) -> {RT, RC+1};
        ((NowBigSec - RTSec) >= ?ONEMIN) -> {Now, 1}
      end;
    ((NowMega - RTMega) > 1) -> {Now, 1};
    ((NowSec - RTSec) < ?ONEMIN) -> {RT, RC+1};
    ((NowSec - RTSec) >= ?ONEMIN) -> {Now, 1}
  end.

  %{Now, RC}.


-define(RESTARTS, 5).
restart_child(Pid, ChildList, StopReason) ->
  % M,F,A - module, function, arguments
  % T,RT,RC - type, restart time, restart counter
  {value, {Pid, {M,F,A,T,RT,RC}}} = lists:keysearch(Pid, 1, ChildList),
  {UpRT, UpRC} = update_child_restart_time(RT,RC),
  if
    % job has already been restarted for 5 times
    (UpRC >= ?RESTARTS) -> lists:keydelete(Pid,1,ChildList);
    % restart if permanent job failed or transident job stopped with error
    (T == permanent) or ((T == transident) and (StopReason =/= normal)) ->
      {ok, NewPid} = apply(M,F,A),
      [{NewPid, {M,F,A,T,UpRT,UpRC}}|lists:keydelete(Pid,1,ChildList)];
    % tarnsident job stopped without problem (don't restart it)
    (T == transident) -> lists:keydelete(Pid,1,ChildList)
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
