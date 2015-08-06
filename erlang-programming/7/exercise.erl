-module(exercise).
-compile(export_all).


%%%% 7-1 Extending records
-record(person, {name,age=0,phone,address}).

joe() -> #person{name="Joe"}.
set_age(P, Age) -> P#person{age=Age}.
set_phone(P, Phone) -> P#person{phone=Phone}.
set_address(P, Address) ->P#person{address=Address}.
birthday(#person{age=Age} = P) -> P#person{age=Age+1}.

showPerson(#person{age=Age,phone=Phone,name=Name,address=Address}) ->
  io:format("name: ~p age: ~p phone: ~p address: ~p~n", [Name,Age,Phone,Address]).

%%%% 7-2 Record quards
foobar(P, Name) when P#person.name == Name -> io:format("name == ~p~n", [Name]);
foobar(_P, Name) -> io:format("name =/= ~p~n", [Name]).

%%%% 7-4 Records and shapes
-record(circle,{radius}).
-record(rectangle,{length, width}).

% init
circle(Radius) -> #circle{radius=Radius}.
rectangle(Length, Width) -> #rectangle{length=Length, width=Width}.

perimeter(Object) ->
  if
    is_record(Object, rectangle) == true -> rectangle_perimeter(Object);
    is_record(Object, circle) == true -> circle_perimeter(Object)
  end.

area(Object) ->
  if
    is_record(Object, rectangle) == true -> rectangle_area(Object);
    is_record(Object, circle) == true -> circle_area(Object)
  end.


rectangle_perimeter(#rectangle{width=Width, length=Length}) ->
  io:format("Rectangle (~p x ~p) perimeter is ~p.~n", [Width, Length, 2*(Width+Length)]).

rectangle_area(#rectangle{width=Width, length=Length}) ->
  io:format("Rectangle (~p x ~p) area is ~p.~n", [Width, Length, Width * Length]).

circle_perimeter(#circle{radius=R}) ->
  io:format("Circle (r=~p) perimeter is ~p.~n", [R, 2 * math:pi() * R]).

circle_area(#circle{radius=R}) ->
    io:format("Circle (r=~p) area is ~p.~n", [R, math:pi() * R * R]).


%%%% 7-5 Binary tree records
