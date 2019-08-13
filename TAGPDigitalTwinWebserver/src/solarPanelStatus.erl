-module(solarPanelStatus).
-export([start/0, init/0,setStatus/2,getStatus/1,setPidLink/2,getPidLink/1,updateStatus/2]). 

start() ->
	register(solarPanelStatus, spawn(?MODULE, init, [])).

updateStatus(Name , Data)-> 
	ets:update_element(logboeksolarPanelStatus, Name, {2, Data}).

setPidLink(Name,Data)-> 
	ets:insert(logboeksolarPanelStatus, {Name, Data}).

setStatus(Name,Data)-> 
	ets:insert(logboeksolarPanelStatus, {Name, Data}).

init() -> 
	ets:new(logboeksolarPanelStatus, [named_table, ordered_set, public]),	
	ets:insert(logboeksolarPanelStatus, {led, notDefined}),	
	loop().

loop() -> 
	receive
		stop -> ok
end.

getStatus(Name) ->

	[{_,Value}] = ets:lookup(logboeksolarPanelStatus, Name),
	Value. 
getPidLink(Name) ->

	[{_,Value}] = ets:lookup(logboeksolarPanelStatus, Name),
	Value. 
