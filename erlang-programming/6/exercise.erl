-module(exercise).
-compile(export_all).


%%%%%%%% 6-1 The linked ping pong server
echo_start() ->
  register(echo, spawn_link(exercise, echo_loop, [])), self().

echo_print(Msg) -> echo ! {message, Msg}, ok.

echo_stop() -> echo ! {command, stop}, ok.

echo_loop() ->
  %io:format("server pid: ~p~n",[self()]),
  process_flag(trap_exit, true),
  echo_loop_loop().

echo_loop_loop() ->
  receive
    {command, stop} -> exit(blabla);
    {message, Msg} -> io:format("~s~n", [Msg]), echo_loop_loop();
    {'EXIT', Pid, Reason} -> io:format("Received EXIT of ~p with reason: ~p.~n", [Pid, Reason])
  end.
