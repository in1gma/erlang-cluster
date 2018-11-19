-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").

main() -> #dtl{file = "index", app=info, bindings=[{body,body()}]}.

body() -> R = rpc:call(mnesia@node1, app_mnesia, select_all, [esp]),
          [#span{id=body, body=R}].

