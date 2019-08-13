-module(survivorUser).
-export([start/0, entry/1, init/0]). 

start() ->
	(whereis(survivorUser) =:= undefined) orelse unregister(survivorUser), 
	register(survivorUser, spawn(?MODULE, init, [])).

entry(Data)-> 
	ets:insert(logboekUser, {{erlang:timestamp(), self()}, Data}). 


init() -> 
	(ets:info(logboekUser) =:= undefined) orelse ets:delete(logboekUser),
	ets:new(logboekUser, [named_table, ordered_set, public]),		
	loop().

loop() -> 
	receive
		stop -> ok
	end. 






