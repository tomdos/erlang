-module(test).
-compile([export_all]).

-include("message_piqi.hrl").

decode(Buf)->
    message_piqi:parse_message(Buf).

encode(Msg)-> 
    message_piqi:gen_message(Msg).

run()->
    Msg = #message_message{id = 65, text = "abc"},
    io:format("Msg: ~p~n",[Msg]),
    EMsg = encode(Msg),
    io:format("Encoded: ~p~n",[EMsg]),
    DMsg = decode(EMsg),
    io:format("Decoded~p~n",[DMsg]).