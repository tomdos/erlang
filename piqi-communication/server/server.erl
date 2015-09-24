-module(server).
-export([start/0, start/1]).

-define(PORT, 1234).

%% API
start() -> listen(?PORT).
start(Port) -> listen(Port).


listen(Port) -> Port.

wait_connection(ListenSocket, Count) -> ok.

connection(Socket, BinaryList, Count) -> ok.
