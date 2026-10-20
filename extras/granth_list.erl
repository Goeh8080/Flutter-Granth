% Standalone sample; not part of the app build.
-module(granth_list).
-export([main/0]).

main() ->
    Granths = ["Gita", "Kabir Sagar", "Ved"],
    lists:foreach(fun({I, G}) -> io:format("~p. ~s~n", [I, G]) end,
                  lists:zip(lists:seq(1, length(Granths)), Granths)).
