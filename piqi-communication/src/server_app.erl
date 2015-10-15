-module(server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).


-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    server_sup:start_link().

stop(_State) ->
    ok.


-ifdef(TEST).

simple_test() ->
    ok = application:start(server),
    ?assertNot(undefined == whereis(server_sup)).

-endif.
