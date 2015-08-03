-module(exercise).
-compile(export_all).

%%%%%%%% 4-1 An Echo server
echo_start() ->
  register(echo, spawn(exercise, echo_loop, [])), ok.

echo_print(Msg) -> echo ! {message, Msg}, ok.

echo_stop() -> echo ! {command, stop}, ok.

echo_loop() ->
  %io:format("OK").
  receive
    {command, stop} -> ok;
    {message, Msg} -> io:format("~s~n", [Msg]), echo_loop()
  end.


%%%%%%%% 4-2 The process ring
ring_start(M, N, Msg) -> spawn(?MODULE, ring_first, [M, N, Msg]), ok.

% fork of the first node
ring_first(M, N, Msg) -> ring_fork(M-1, N, Msg, 1, self()).

%ring_start_fork_first()
ring_fork(M, N, Msg, MyID, FirstPid) ->
  if
    M == 0 ->
      ring_send(FirstPid, MyID, Msg),
      ring_recv_loop(N-1, Msg, MyID, FirstPid);
    M =/= 0 ->
      Pid = spawn(?MODULE, ring_fork, [M-1, N, Msg, MyID+1, FirstPid]),
      ring_send(Pid, MyID, Msg),
      ring_recv_loop(N-1, Msg, MyID, Pid)
  end.

% send message
ring_send(Receiver, ID, Msg) -> Receiver ! {ID, Msg}.

% single process - waiting for incomming message and processe it of forward it
ring_recv_loop(0, _Msg, MyID, _Next) -> io:format("MyID ~B: stoped~n", [MyID]);
ring_recv_loop(N, Msg, MyID, Next) ->
  %io:format("MyID: ~B, Pid ~p, Next: ~p ~n", [MyID, self(), Next]),
  receive
    %{A, B} -> io:format("dbg ~B ~s ~n", [A,B]);
    % received my message, new loop
    {MyID, Msg} ->
      io:format("MyID: ~B: ~s (~B)~n", [MyID, Msg, N+1]),
      ring_send(Next, MyID, Msg),
      ring_recv_loop(N-1, Msg, MyID, Next);
    % received msg of other process, pass it to the Next
    {RecID, RecMsg} ->
      %o:format("dbg ~B: {~B, ~s} ~n", [MyID, RecID, RecMsg]),
      %Next ! {RecID, RecMsg},
      ring_send(Next, RecID, RecMsg),
      ring_recv_loop(N, Msg, MyID, Next)
  end.
