-module(my_db_app).
-export([start/2, stop/1]).
-behaviour(application).

start(_Type, _Args) ->
  my_db_sup:start().

stop(_State) -> ok.