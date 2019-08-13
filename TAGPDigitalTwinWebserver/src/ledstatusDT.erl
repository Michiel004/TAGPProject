-module(ledstatusDT).
-export([start/0, init/0,setStatus/2,getStatus/1,setPidLink/2,getPidLink/1,updateStatus/2]). 

start() ->
	register(ledstatusDT, spawn(?MODULE, init, [])).

updateStatus(Name , Data)-> 
	ets:update_element(logboekledStatusDT, Name, {2, Data}).

setPidLink(Name,Data)-> 
	ets:insert(logboekledStatusDT, {Name, Data}).

setStatus(Name,Data)-> 
	ets:insert(logboekledStatusDT, {Name, Data}).

init() -> 
	ets:new(logboekledStatusDT, [named_table, ordered_set, public]),	
	ets:insert(logboekledStatusDT, {led, notDefined}),	
	loop().

loop() -> 
	receive
		stop -> ok
end.

getStatus(Name) ->

	[{_,Value}] = ets:lookup(logboekledStatusDT, Name),
	Value. 
getPidLink(Name) ->

	[{_,Value}] = ets:lookup(logboekledStatusDT, Name),
	Value. 







