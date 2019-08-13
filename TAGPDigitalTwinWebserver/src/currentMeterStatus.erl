-module(currentMeterStatus).
-export([start/0, init/0,setStatus/2,getStatus/1]). 

start() ->
    (whereis(currentMeterStatus) =:= undefined) orelse unregister(currentMeterStatus), 
	register(currentMeterStatus, spawn(?MODULE, init, [])).

setStatus(ID,Data)-> 
	%ets:update_element(logboeksupervisor, ID, {2, Data}).
	ets:insert(logboekcurrentMeter, {ID, Data}).
init() -> 
	ets:new(logboekcurrentMeter, [named_table, ordered_set, public]),	
	%ets:insert(logboeksupervisor, {[ledRed, totalRes], notDefined}),
	loop().

loop() -> 
	receive
		stop -> ok
end.

getStatus(ID) ->

	[{_,Value}] = ets:lookup(logboekcurrentMeter, ID),
	Value. 






