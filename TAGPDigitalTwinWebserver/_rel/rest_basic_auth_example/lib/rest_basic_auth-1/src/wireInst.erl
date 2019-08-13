-module(wireInst).
-export([create/2, init/2, get_flow_influence/1, adapt_connectors/2, adapt_locations/2,set_resistance/2,get_resistance/1]).


create(Host, ResTyp_Pid) -> {ok, spawn(?MODULE, init, [Host, ResTyp_Pid])}.

init(Host, ResTyp_Pid) -> 
%	{ok, State} = apply(resource_type, get_initial_state, [ResTyp_Pid, self(), []]),	
	{ok, State} = resource_type:get_initial_state(ResTyp_Pid, self(), []),
	survivor:entry({ wireInst_created, State }),
	loop(Host, State, ResTyp_Pid).

get_flow_influence(PipeInst_Pid) -> 
	msg:get(PipeInst_Pid, get_flow_influence).

adapt_connectors(PipeInst_Pid, NewResInst) ->
	PipeInst_Pid ! {adapt_connectors, NewResInst}.

adapt_locations(PipeInst_Pid, NewResInst) ->
	PipeInst_Pid ! {adapt_locations, NewResInst}.

set_resistance(PipeInst_Pid,Value) ->
	PipeInst_Pid ! {setResistance,Value},
	survivorUser:entry({PipeInst_Pid,resistanceIsSet,Value}).

get_resistance(PipeInst_Pid) -> 
	msg:get(PipeInst_Pid, isResistance). 

loop(Host, State, ResTyp_Pid) -> 
	receive
		{adapt_locations, NewResInst} ->
			{ok, List} = resource_type:get_locations_list(ResTyp_Pid, State), 
			updateLocations(List, NewResInst), 
			loop(Host, State, ResTyp_Pid);
		{adapt_connectors, NewResInst} ->
			{ok,C_List} = resource_type:get_connections_list(ResTyp_Pid, State), 
			updateConnectors(C_List, NewResInst), 
			loop(Host, State, ResTyp_Pid);
		{get_connectors, ReplyFn} ->
			{ok,C_List} = resource_type:get_connections_list(ResTyp_Pid, State), 
			ReplyFn(C_List),
			loop(Host, State, ResTyp_Pid);
		{get_locations, ReplyFn} ->
			{ok, List} = resource_type:get_locations_list(ResTyp_Pid, State),
			ReplyFn(List),
			loop(Host, State, ResTyp_Pid);
		{get_type, ReplyFn} -> 
			ReplyFn(ResTyp_Pid),
			loop(Host, State, ResTyp_Pid);
		{get_ops, ReplyFn} ->
			ReplyFn([]),
			loop(Host, State, ResTyp_Pid);
		{get_state, ReplyFn} ->
			ReplyFn(State),
			loop(Host, State, ResTyp_Pid);
		{get_flow_influence, ReplyFn} ->
			{ok, InfluenceFn} = msg:get(ResTyp_Pid, get_flow_influence, State),
			ReplyFn(InfluenceFn),
			loop(Host, State, ResTyp_Pid);
		{set_host, NewHost} ->
			loop(NewHost, State, ResTyp_Pid);
		{setResistance, Value} -> 
			{ok, State} = msg:set_ack(ResTyp_Pid, {setResistance, Value}, State),
			%notify_subscribers(Subcriber_List, {self(), setResistance}), 
			loop(Host, State, ResTyp_Pid);
		{isResistance, ReplyFn} -> 
			{ok, Answer} = msg:get(ResTyp_Pid, isResistance, State), 
			ReplyFn(Answer), 
			loop(Host, State, ResTyp_Pid);
		{get_host, ReplyFn} -> 
			ReplyFn(Host), 
			loop(Host, State, ResTyp_Pid)
	end.
	

updateLocations([ C | Remainder ], NewResInst) ->
	location:set_ResInst(C,  NewResInst),
    updateLocations(Remainder, NewResInst);

updateLocations([], _ ) -> ok. 

updateConnectors([ C | Remainder ], NewResInst) ->
	connector:set_ResInst(C,  NewResInst),
    updateConnectors(Remainder, NewResInst);

updateConnectors([], _ ) -> ok. 


