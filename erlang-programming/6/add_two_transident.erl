% similar to add_two but transident solution - return the rusult just once end exit
-module(add_two_transident).
-export([start/0, request/1, loop/0, stop/0]).

start() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(add_two_transident, loop, []),
  register(add_two_transident, Pid),
  {ok, Pid}.

stop() -> add_two_transident ! stop.

request(Int) ->
  add_two_transident ! {request, self(), Int},
  receive
    {result, Result} -> Result;
    {'EXIT', _Pid, Reason} -> {error, Reason}
  after
    1000 -> timeout
  end.

loop() ->
  receive
    {request, Pid, Msg} -> Pid ! {result, Msg + 2};
    stop -> exit(stop_by_user)
  end,
  exit(normal).
