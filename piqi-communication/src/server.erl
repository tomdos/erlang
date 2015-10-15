-module(server).
-compile([export_all]).

-define(PORT, 1234).


%% Public API
start() -> start(?PORT).
start(Port) -> spawn_link(?MODULE, listen, [Port]), ok.



listen(Port) ->
  {ok, Socket} = gen_tcp:listen(Port, [binary, {active, false}]),
  wait_connect(Socket, 1).

wait_connect(ListenSocket, Count) ->
  io:format("~p -> wailt_connect~n", [self()]),
  {ok, NewSocket} = gen_tcp:accept(ListenSocket),
  %spawn(?MODULE, wait_connect, [ListenSocket, Count+1]),
  %request(NewSocket, [], Count).
  spawn(?MODULE, request, [NewSocket, [], Count]),
  wait_connect(ListenSocket, Count+1).

request(Socket, BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0, 5000) of
    {ok, Binary} -> request(Socket, [Binary|BinaryList], Count);
    {error, closed} -> gen_tcp:close(Socket),
      process_request(lists:reverse(BinaryList), Count)
  end.

process_request(BinaryList, Count) ->
  io:format("~p -> ~p (~p)~n", [self(), BinaryList, Count]), ok.
