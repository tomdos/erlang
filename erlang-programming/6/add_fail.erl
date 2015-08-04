% failing module - fail after one second
-module(add_fail).
-export([start/0, loop/0]).

start() ->
  process_flag(trap_exit, true),
  Pid = spawn_link(add_fail, loop, []),
  register(add_fail, Pid),
  {ok, Pid}.

loop() ->
  receive
  after
    1000 -> ok
  end,
  exit(some_terible_failure).
