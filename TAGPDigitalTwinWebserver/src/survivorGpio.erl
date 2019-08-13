-module(survivorGpio).
-export([start/0, entry/1, init/0]). 

start() ->
	(whereis(survivorGpio) =:= undefined) orelse unregister(survivorGpio), 
	register(survivorGpio, spawn(?MODULE, init, [])).

entry(Data)-> 
	ets:insert(logboekGpio, {{erlang:timestamp(), self()}, Data}). 


init() -> 
	(ets:info(logboekGpio) =:= undefined) orelse ets:delete(logboekGpio),
	ets:new(logboekGpio, [named_table, ordered_set, public]),		
	loop().

loop() -> 
	receive
		stop -> ok
	end. 






