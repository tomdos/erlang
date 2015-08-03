-module(send_exit).
-compile(export_all).

start()-> register(send_exit, spawn_link(send_exit, loop, [0])).
stop() -> send_exit ! {stop}.

send() -> link(whereis(send_exit)), exit(kill).
print() -> send_exit ! {print}.


loop(Cnt) ->
  process_flag(trap_exit, true),
  receive
    {print} -> io:format("counter = ~B", [Cnt]), loop(Cnt);
    {stop} -> io:format("stopping");
    %_ -> io:format("received msg~n"), loop(Cnt+1);
    {'EXIT', Pid, Reason} -> io:format("Pid: ~p, Reason: ~p~n",[Pid, Reason]), loop(Cnt+1)
  %after
  %  3000 -> io:format("end~n")
  end.
