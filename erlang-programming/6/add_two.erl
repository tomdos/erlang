% example from the book used by exercise_supervisor
-module(add_two).
-export([start/0, request/1, loop/0, stop/0]).

start() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(add_two, loop, []),
  register(add_two, Pid),
  {ok, Pid}.

stop() -> add_two ! stop.

request(Int) ->
  add_two ! {request, self(), Int},
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
  loop().
