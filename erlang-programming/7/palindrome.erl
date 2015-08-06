-module(palindrome).
-compile(export_all).


palindrome(List) ->
  palindrome_int(palindrome_rev(List, []), List).

% compare reversed list with the original list
palindrome_int([], []) -> true;
palindrome_int([HA|TA] = _ListA, [HB|TB] = _ListB) ->
  case HA == HB of
    true -> palindrome_int(TA, TB);
    false -> false
  end.

% reverse a list
palindrome_rev([], Acc) -> Acc;
palindrome_rev([H|T] = _List, Acc) -> palindrome_rev(T, [H|Acc]).
