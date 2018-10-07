-module(app_mnesia).
-import(lists, [foreach/2]).
-export([init/1]).

-record(esp, {name, power, cost}).

init(Args) ->
   create_db(),
   ping_nodes(Args),
   make_cluster(),
   test().

create_db() ->
   mnesia:create_schema([node()]),
   mnesia:start(),
   mnesia:create_table(esp, [{disc_copies, [node()]}, {attributes, record_info(fields, esp)}]).

ping_nodes(Nodes) ->
   foreach(fun(Node) ->
      net_adm:ping(Node)
   end, Nodes).

make_cluster() ->
   mnesia:change_config(extra_db_nodes, nodes()),
   foreach(fun(Node) ->
      mnesia:change_table_copy_type(schema, Node, disc_copies),
      mnesia:add_table_copy(esp, Node, disc_copies)
   end, nodes()).

test() ->
   io:format("All nodes: ~p\n", [[node()|nodes()]]),
   fill_tables(),
   mnesia:info(),
   traverse_table_and_show(esp).
   
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

traverse_table_and_show(Table_name)->
   Iterator = fun(Rec,_)->
      io:format("~p~n",[Rec]),
         []
      end,
   case mnesia:is_transaction() of
      true -> mnesia:foldl(Iterator,[],Table_name);
      false -> 
         Exec = fun({Fun,Tab}) -> mnesia:foldl(Fun, [],Tab) end,
         mnesia:activity(transaction,Exec,[{Iterator,Table_name}],mnesia_frag)
      end.
