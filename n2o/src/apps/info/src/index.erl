-module(index).
-compile(export_all).

-include_lib("nitro/include/nitro.hrl").
-include_lib("n2o/include/wf.hrl").

main() -> #dtl{file = "index", app=info, bindings=[{body,body()}]}.

body() -> % F = fun () -> mnesia:read({esp, borets}) end,
          % R = rpc:call(mnesia@node1, mnesia, transaction, [F]),
          R = rpc:call(mnesia@node1, app_mnesia, select_all, [esp]),
          % io:format("~p~n", [R]),
          % register(api, spawn(fun loop/0)),
          % {api, mnesia@node1} ! {select, esp, node(), api, push},
          [#span{id=body, body=R}].

loop() ->
    receive
        {push, Data} ->
            io:format("~p~n", [Data]),
            wf:update(body, #span{id=body, body=Data})
            % loop()
        end.
