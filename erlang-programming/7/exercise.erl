-module(exercise).
-compile(export_all).


% 7-1 Extending records
-record(person, {name,age=0,phone,address}).

joe() -> #person{name="Joe"}.
set_age(P, Age) -> P#person{age=Age}.
set_phone(P, Phone) -> P#person{phone=Phone}.
set_address(P, Address) ->P#person{address=Address}.
birthday(#person{age=Age} = P) -> P#person{age=Age+1}.

showPerson(#person{age=Age,phone=Phone,name=Name,address=Address}) ->
  io:format("name: ~p age: ~p phone: ~p address: ~p~n", [Name,Age,Phone,Address]).

% 7-2 Record quards
foobar(P, Name) when P#person.name == Name -> io:format("name == ~p~n", [Name]);
foobar(_P, Name) -> io:format("name =/= ~p~n", [Name]).

% 7-3 The db.erl exercise revisited
