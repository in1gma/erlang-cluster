-module(app_mnesia).
-export([start/0, stop/0]).

-record(esp, {name, power, cost}).

start() ->
   io:format("mnesia: starting ...\n"),
   mnesia:create_schema([node()|nodes()]),
   mnesia:start(),
   mnesia:create_table(esp, [{disk_copies, [node()|nodes()]}, {attributes, record_info(fields, esp)}]),
   io:format("mnesia: started!!\n").

stop() ->
   mnesia:stop().  
