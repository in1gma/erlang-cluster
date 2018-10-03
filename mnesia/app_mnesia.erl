-module(app_mnesia).
-import(lists, [foreach/2]).
-export([start/0]).

-record(esp, {name, power, cost}).

start() ->
   io:format("mnesia: createing ...\n"),
   mnesia:create_schema([node()|nodes()]),
   mnesia:start(),
   mnesia:create_table(esp, [{disc_copies, [node()|nodes()]}, {type, set}, {attributes, record_info(fields, esp)}]),
   io:format("mnesia: created!!\n"),
   operations().

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
