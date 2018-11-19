-module(app_mnesia).
-import(lists, [foreach/2]).
-export([init/1, select_all/1]).

-include_lib("stdlib/include/qlc.hrl").

-record(esp, {name, power, cost}).

init(Args) ->
   ping_nodes(Args),
   create_db(),
   test().

create_db() ->
   mnesia:create_schema([node()]),
   mnesia:start(),
   mnesia:change_config(extra_db_nodes, nodes()),
   foreach(fun(Node) ->
      mnesia:change_table_copy_type(schema, Node, disc_copies)
   end, nodes()),
   mnesia:create_table(esp, [{disc_copies, [node()|nodes()]}, {attributes, record_info(fields, esp)}]).

ping_nodes(Nodes) ->
   foreach(fun(Node) ->
      net_adm:ping(Node)
   end, Nodes).

test() ->
   fill_tables(),
   register(api, spawn(fun loop/0)).

data() ->
   [
      {esp, borets, 115, 1000},
      {esp, alnas, 125, 1213},
      {esp, novomet, 100, 900}
   ].

fill_tables() ->
   mnesia:clear_table(esp),
   F = fun() ->
      foreach(fun mnesia:write/1, data())
   end,
   mnesia:transaction(F).

select_all(Table) ->
    do(qlc:q([X || X <- mnesia:table(Table)])).

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Result} = mnesia:transaction(F),
    Result.

loop() ->
    receive
        {select, Params, Sender, Process, Path} ->
            Result = select_all(Params),
            {Process, Sender} ! {Path, Result},
            loop()
        end.
