-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").

main() -> #dtl{file = "index", app=info, bindings=[{body,body()}]}.

body() -> [#span{body=rpc:call(mnesia@node3, mnesia, transaction, [fun () -> mnesia:read({esp, borets}) end])}].
