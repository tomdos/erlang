-module(ifcase).
-compile(export_all).

getday(N) ->
  %getday_case(N).
  getday_if(N).

getday_if(N) ->
  if
    N == 1 -> monday;
    N == 2 -> tuesday;
    % etc
    N == 7 -> sunday
  end.

getday_case(N) ->
  case N of
    1 -> monday;
    2 -> tuesday;
    3 -> wednesday;
    4 -> thursday;
    5 -> friday;
    6 -> saturday;
    7 -> sunday
  end.
