-module(server).
-compile([export_all]).

-include("message_piqi.hrl").

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

request(Socket, _BinaryList, Count) ->
  case gen_tcp:recv(Socket, 0) of
    {ok, Binary} ->
        io:format("receiving~n"),
        % I should deal with possibility that received message is not whole.
        Request = process_request(Binary, Count),
        response(Socket, Request),
        request(Socket, [], Count);
    {error, _} -> gen_tcp:close(Socket),
        io:format("connection closed~n")
  end.

%process_request([], _) -> ok;
process_request(Binary, Count) ->
    io:format("~p~n", [Binary]),
    Request = message_piqi:parse_message(Binary),
    io:format("~p -> ~p (~p)~n", [self(), Request, Count]),
    Request.

response(Socket, Request) ->
    Response = prepare_response(Request),
    io:format("response encoded: ~p~n", [Response]),
    case gen_tcp:send(Socket, Response) of
        {error, Reason } -> io:format("response error: ~p~n", Reason);
        ok -> ok
    end.

prepare_response(Request) ->
    Msg = "Message '" ++ binary:bin_to_list(Request#message_message.msg) ++ "' has been received",
    Response = #message_message {
        id = Request#message_message.id,
        msg = Msg,
        type = response
    },
    io:format("response: ~p~n", [Response]),
    message_piqi:gen_message(Response).
