%6-2 A Reliable mutex semaphore - solution with try-catch/link/unlink
-module(exercise_mutex).
-export([start/0, stop/0]).
-export([wait/0, signal/0]).
-export([init/0]).


start() ->
  register(mutex, spawn(?MODULE, init, [])).

stop() ->
  mutex ! stop.

wait() ->
  mutex ! {wait, self()},
  receive ok -> ok end.

signal() ->
  mutex ! {signal, self()}, ok.

init() -> process_flag(trap_exit, true), io:format("~p~n", [self()]), free().

free() ->
  receive
    {wait, Pid} -> Pid ! ok, busy(Pid);
    {signal, _} -> free();
    {'EXIT', _, _} -> free();
    stop -> terminate()
  end.

link_pid(Pid) ->
  try link(Pid) of
    _-> true
  catch
    _:_ -> false
  end.

unlink_pid(Pid) ->
  try unlink(Pid) of
    _-> true
  catch
    _:_ -> false
  end.

busy(Pid) ->
  io:format("[locked] "),
  case link_pid(Pid) of
    true ->
      receive
        {signal, Pid} ->
          io:format("[free] "),
          unlink_pid(Pid),
          free();
        {'EXIT', Pid, _} -> io:format("received signal~n"), free()
      end;
  false -> free()
  end.

terminate() ->
  receive
    {wait, Pid} -> exit(Pid, kill), terminate()
  after
    0 -> ok
  end.
