-module(index).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").

main() -> #dtl{file = "index", app=info, bindings=[{body,body()}]}.

body() -> [#span{body="Hello!!"}].
