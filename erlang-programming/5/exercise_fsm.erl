% 5-5  Phone FSM
-module(exercise_fsm).
-compile(export_all).

start(MyNumber) -> registe(MyNumber, spawn(exercise_fsm, idle, [])).

%hang_up()
%pick_up() ->
call_number(Number) -> ok.



idle() ->
  receive
    {Number, incoming} -> start_ringing(), ringing(Number);
    off_hook -> start_tone(),
    dial()
  end.

ringing(Number) ->
  receive
    {Number, other_on_hook} -> stop_ringing(),
    idle();
    {Number, off_hook} ->stop_ringing(),
    connected(Number)
  end.

dial(Number) -> ok.

connected(Number) -> ok.


start_ringing() -> io:format("Phone is ringing.").

start_tone() -> ok.

stop_ringing() -> busy.
