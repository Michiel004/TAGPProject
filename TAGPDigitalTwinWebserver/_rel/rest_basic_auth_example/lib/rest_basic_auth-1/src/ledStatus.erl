-module(ledStatus).
-export([start/0, init/0,setStatus/1,getStatus/1]). 

start() ->
	(whereis(ledStatus) =:= undefined) orelse unregister(ledStatus), 
	register(ledStatus, spawn(?MODULE, init, [])).

setStatus(Data)-> 
	ets:update_element(logboekledStatus, led, {2, Data}).

init() -> 
	ets:new(logboekledStatus, [named_table, ordered_set, public]),	
	ets:insert(logboekledStatus, {led, notDefined}),	
	loop().

loop() -> 
	receive
		stop -> ok
end.

getStatus(Name) ->

	[{_,Value}] = ets:lookup(logboekledStatus, Name),
	Value. 






