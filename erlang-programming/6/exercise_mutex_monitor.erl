%6-2 A Reliable mutex semaphore - solution with monitor
-module(exercise_mutex_monitor).
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
    {wait, Pid} -> Pid ! ok, busy(Pid, monitor(process, Pid));
    {signal, _} -> free();
    stop -> terminate()
  end.

busy(Pid, Reference) ->
  io:format("[locked] "),
  receive
    {signal, Pid} ->
      io:format("[free] "),
      free();
    {_, Reference, process, Pid, _} -> io:format("received signal~n"), free()
  end.

terminate() ->
  receive
    {wait, Pid} -> exit(Pid, kill), terminate()
  after
    0 -> ok
  end.
