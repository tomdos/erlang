-module(echoprocess).
%-export([go/0, loop/0]).
-compile(export_all).

go() ->
  Pid = spawn(echoprocess, loop, []), Pid ! {self(), hello},
  receive
    {Pid, Msg} ->
      io:format("~w~n",[Msg])
    end,
    Pid ! stop.

loop() ->
  receive
    {From, Msg} -> From ! {self(), Msg}, loop();
    stop -> true
  end.



waitformsg() ->
  register(echoprocess,  spawn(echoprocess, waitformsg_loop, [])).

waitformsg_loop() ->
  receive
    stop -> true;
    Msg -> io:format("msg received: ~s~n",[Msg]), waitformsg_loop()
  end.
