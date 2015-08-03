%% 5-2 Changing the frequency server

-module(exercise_freq).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).
-compile(debug_info).

%% These are the start functions used to create and %% initialize the server.
start() -> register(exercise_freq, spawn(exercise_freq, init, [])).
init() -> Frequencies = {get_frequencies(), []}, loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%% The client Functions
stop() -> call(stop).
allocate() -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

%% We hide all message passing and the message %% protocol in a functional interface.
call(Message) -> exercise_freq ! {request, self(), Message},
  receive
    {reply, Reply} -> Reply
  end.


%% The Main Loop
loop(Frequencies) ->
  io:format("~p~n", [Frequencies]),
  receive
    {request, Pid, allocate} ->
      case limit_clients_freq(Frequencies, Pid) of
        true ->
          {NewFrequencies, Reply} = allocate(Frequencies, Pid),
          reply(Pid, Reply),
          loop(NewFrequencies);
        false ->
          reply(Pid, false),
          loop(Frequencies)
      end;
    {request, Pid , {deallocate, Freq}} ->
      case deallocate(Frequencies, Freq, Pid) of
        false -> reply(Pid, false), NewFrequencies = Frequencies;
        L -> reply(Pid, ok), NewFrequencies = L
      end,
      loop(NewFrequencies);
    {request, Pid, stop} ->
      reply(Pid, ok)
  end.

reply(Pid, Reply) -> Pid ! {reply, Reply}.

% limit the number of frequencies a client can allocate
limit_clients_freq({_Free, Allocated}, Pid) ->
  L = [P || {_F, P} <- Allocated, P == Pid],
  length(L) < 3.


%% The Internal Help Functions used to allocate and %% deallocate frequencies.
allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};
allocate({[Freq|Free], Allocated}, Pid) ->
  {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}.

deallocate({Free, Allocated}, Freq, Pid) ->
  case O = lists:keysearch(Freq, 1, Allocated) of
    false -> false;
    _ ->
    case O =:= {value, {Freq, Pid}} of
      true -> NewAllocated=lists:keydelete(Freq, 1, Allocated), {[Freq|Free], NewAllocated};
      false -> false
    end
  end.
