-module(ledLoger).
-export([start/0, entry/1, init/0]). 

start() ->
	register(ledLoger, spawn(?MODULE, init, [])).

entry(Data)-> 
	ets:insert(ledStatus, {{erlang:timestamp(), self()}, Data}). 

init() -> 
	ets:new(ledStatus, [named_table, ordered_set, public]),		
	loop().

loop() -> 
	receive
		stop -> ok
end. 






