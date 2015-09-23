-module(dist).
-compile(export_all).

f(From) -> From ! node().

