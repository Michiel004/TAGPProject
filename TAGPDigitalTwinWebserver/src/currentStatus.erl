-module(currentStatus).
-export([start/0, init/0,setStatus/2,getStatus/1]). 

start() ->
    (whereis(supervisorStatus) =:= undefined) orelse unregister(supervisorStatus), 
	register(supervisorStatus, spawn(?MODULE, init, [])).

setStatus(ID,Data)-> 
	%ets:update_element(logboeksupervisor, ID, {2, Data}).
	ets:insert(logboeksupervisor, {ID, Data}).
init() -> 
	ets:new(logboeksupervisor, [named_table, ordered_set, public]),	
	%ets:insert(logboeksupervisor, {[ledRed, totalRes], notDefined}),
	loop().

loop() -> 
	receive
		stop -> ok
end.

getStatus(ID) ->

	[{_,Value}] = ets:lookup(logboeksupervisor, ID),
	Value. 







