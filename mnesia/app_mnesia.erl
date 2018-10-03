-module(app_mnesia).
-import(lists, [foreach/2]).
-export([start/1]).

-record(esp, {name, power, cost}).

start(Args) ->
   ping_nodes(Args),
   create_db(),
   operations(). %% fill and test

create_db() ->
   mnesia:create_schema([node()|nodes()]),
   mnesia:start(),
   mnesia:create_table(esp, [{ram_copies, [node()|nodes()]}, {type, set}, {attributes, record_info(fields, esp)}]).

ping_nodes(Nodes) ->
   io:format("Nodes to ping: ~p\n", [Nodes]),
   foreach(fun(Node) ->
      io:format("Node: ~p is ~p\n", [Node, net_adm:ping(Node)])
   end, Nodes),
   io:format("All nodes: ~p\n", [[node()|nodes()]]).

operations() ->
   mnesia:wait_for_tables([esp], 20000),
   fill_tables(),
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
