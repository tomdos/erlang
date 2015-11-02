-module(test).
-compile([export_all]).

-include("message_piqi.hrl").

decode(Buf)->
    message_piqi:parse_message(Buf).

encode(Msg)-> 
    message_piqi:gen_message(Msg).

piqiruntest() -> io:format("~p~n", [piqirun:module_info()]).

run()->
    %piqiruntest(),
    Msg = #message_message{id = 65, text = "abc", type = request, info = "some more detailed info"},
    %Msg = #message_message{},
    io:format("Msg: ~p~n",[Msg]),
    EMsg = encode(Msg),
    io:format("Encoded: ~p~n",[EMsg]),
    BEMsg = binary:list_to_bin(EMsg),
    DMsg = decode(BEMsg),
    io:format("Decoded~p~n",[DMsg]).
