-module(server).
-compile([export_all]).

-define(PORT, 1234).

%% API
start() -> listen(?PORT).
start(Port) -> listen(Port).


listen(Port) ->
  {ok, Socket} = gen_tcp:listen(Port, [binary, {active, false}]),
  wait_connect(Socket, 0).

wait_connect(ListenSocket, Count) ->
  io:format("~p -> wailt_connect~n", [self()]),
  {ok, NewSocket} = gen_tcp:accept(ListenSocket),
  spawn(?MODULE, wait_connect, [ListenSocket, Count+1]),
  request(NewSocket, [], Count).

request(Socket, BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0, 5000) of
    {ok, Binary} -> request(Socket, [Binary|BinaryList], Count);
    {error, closed} -> gen_tcp:close(Socket),
      process_request(lists:reverse(BinaryList), Count)
  end.

process_request(BinaryList, Count) ->
  io:format("~p -> ~p~n", [self(), BinaryList]), ok.
