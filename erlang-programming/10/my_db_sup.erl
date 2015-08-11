-module(my_db_sup).
-export([start/0]).
-export([init/1]).
-behaviour(supervisor).

-define(SHUTDOWN_TIMEOUT, 30000).

start() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Args) ->
  DBServer = {my_db_gen, {my_db_gen, start, []}, permanent, ?SHUTDOWN_TIMEOUT, worker, [my_db, my_db_gen]},
  {ok, {{one_for_all, 3, 2}, [DBServer]}}.


