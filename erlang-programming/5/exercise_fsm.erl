% 5-5  Phone FSM
-module(exercise_fsm).
-compile(export_all).

start() -> register(exercise_fsm, spawn(exercise_fsm, idle, [])), ok.
stop() -> exercise_fsm ! {stop}.

%% Controllers
incomming() -> exercise_fsm ! {incomming}.
off_hook() -> exercise_fsm ! {off_hook}.
off_hook(Number) -> exercise_fsm ! {Number, off_hook}.
on_hook() -> exercise_fsm ! {on_hook}.
other_on_hook() -> exercise_fsm ! {other_on_hook}.

%% FSM states
idle() ->
  io:format("[idle]~n"),
  receive
    {incomming} -> start_ringing(), ringing();
    {Number, off_hook} -> start_tone(), dial(Number);
    {stop} -> ok
  end.

ringing() ->
  io:format("[ringing]~n"),
  receive
    {on_hook} -> stop_ringing(), idle();
    {other_on_hook} -> busy_tone(), idle();
    {off_hook} -> stop_ringing(), connected();
    {stop} -> ok
  end.

connected() ->
  io:format("[connected]~n"),
  receive
    {on_hook} -> idle();
    {other_on_hook} -> busy_tone(), idle();
    {stop} -> ok
  end.

dial(Number) ->
  io:format("[dial]~n"),
  receive
    {on_hook} -> idle();
    {off_hook} -> charge(Number);
    {other_on_hook} -> busy_tone(), idle();
    {stop} -> ok
  end.

charge(Number) ->
  io:format("[charge]~n"),
  io:format("Caller of number ~p has been charged. ~n", [Number]),
  connected().

%% Actions output
start_ringing() -> io:format("Phone is ringing.~n").
stop_ringing() -> io:format("Phone stopped ringing.~n").
busy_tone() -> io:format("Phone is busy.~n").
start_tone() -> io:format("Dialling the number.~n").
