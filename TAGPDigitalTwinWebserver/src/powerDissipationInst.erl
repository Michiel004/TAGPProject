-module(powerDissipationInst).
-export([create/4, init/4, switch_on/1, switch_off/1, is_on/1, flow_influence/1, subscribe/2,get_resistance/1,set_resistance/2,get_voltige/1,set_Voltige/2]).
% -export([commission/1, activate/1]).
% -export([deactivate/1, decommission/1]).

% Pump is a pipe and more; this pipe instance is passed to the create function.
% RealWorldCmdFn is a function to transfer commands to the real-world pump. 

create(Host, PowerDissipationyp_Pid, WireInst_Pid, RealWorldCmdFn) -> {ok, spawn(?MODULE, init, [Host, PowerDissipationyp_Pid, WireInst_Pid, RealWorldCmdFn])}.

init(Host, PowerDissipationTyp_Pid, WireInst_Pid, RealWorldCmdFn) ->            
	{ok, State} = resource_type:get_initial_state(PowerDissipationTyp_Pid, Host, {WireInst_Pid, RealWorldCmdFn}),

	wireInst:adapt_connectors(WireInst_Pid, self()), 
	wireInst:adapt_locations(WireInst_Pid, self()), 
	survivor:entry({ powerDissipationInst_created, State }),
	loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, []).

switch_off(PowerDissipationTyp_Pid) ->
	PowerDissipationTyp_Pid ! switchOff,
	survivorGpio:entry({PowerDissipationTyp_Pid,off}).

	
	
switch_on(PowerDissipationTyp_Pid) ->
	PowerDissipationTyp_Pid ! switchOn,
	%io:fwrite("pomp aan")
	survivorGpio:entry({PowerDissipationTyp_Pid,on}).

set_resistance(PowerDissipationTyp_Pid,Value) ->
	PowerDissipationTyp_Pid ! {setResistance,Value},
	survivorUser:entry({PowerDissipationTyp_Pid,resistanceIsSet,Value}).

set_Voltige(PowerDissipationTyp_Pid,Value) ->
	PowerDissipationTyp_Pid ! {setVoltige,Value},
	survivorUser:entry({PowerDissipationTyp_Pid,voltigetanceIsSet,Value}).

get_resistance(PowerDissipationTyp_Pid) -> 
	msg:get(PowerDissipationTyp_Pid, isResistance). 

get_voltige(PowerDissipationTyp_Pid) -> 
	msg:get(PowerDissipationTyp_Pid, getVoltige).

is_on(PowerDissipationTyp_Pid) -> 
	msg:get(PowerDissipationTyp_Pid, isOn).

flow_influence(PowerDissipationTyp_Pid) -> 
	msg:get(PowerDissipationTyp_Pid, get_flow_influence).

subscribe(PowerDissipationTyp_Pid, Subcriber_Pid) -> 
	PowerDissipationTyp_Pid ! {subscribe, Subcriber_Pid}. 


loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List) -> 
	receive
		switchOn -> 
			{ok, NewState} = msg:set_ack(PowerDissipationTyp_Pid, switchOn, State),
			notify_subscribers(Subcriber_List, {self(), switch_on}), 
			loop(Host, NewState, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		switchOff -> 
			{ok, NewState} = msg:set_ack(PowerDissipationTyp_Pid, switchOff, State), 
			notify_subscribers(Subcriber_List, {self(), switch_off}),
			loop(Host, NewState, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{isOn, ReplyFn} -> 
			{ok, Answer} = msg:get(PowerDissipationTyp_Pid, isOn, State), 
			ReplyFn(Answer), 
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{setResistance, Value} -> 
			{ok, NewState} = msg:set_ack(PowerDissipationTyp_Pid, {setResistance, Value}, State),
			notify_subscribers(Subcriber_List, {self(), setResistance}), 
			loop(Host, NewState, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{isResistance, ReplyFn} -> 
			{ok, Answer} = msg:get(PowerDissipationTyp_Pid, isResistance, State), 
			ReplyFn(Answer), 
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{setVoltige, ReplyFn} -> 
			{ok, Answer} = msg:get(PowerDissipationTyp_Pid, getVoltige, State), 
			ReplyFn(Answer), 
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{get_type, ReplyFn} -> 
			ReplyFn(PowerDissipationTyp_Pid),
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{get_flow_influence, ReplyFn} ->
			{ok, InfluenceFn} = msg:get(PowerDissipationTyp_Pid, flow_influence, State),
			ReplyFn(InfluenceFn),
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{get_ops, ReplyFn} ->
			{ok, OpsList} = msg:get(PowerDissipationTyp_Pid, getOps, State),
			ReplyFn(OpsList),
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List);
		{subscribe, Subcriber_Pid} ->
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, [Subcriber_Pid| Subcriber_List]);
		OtherMessage -> 
			WireInst_Pid ! OtherMessage,
			loop(Host, State, PowerDissipationTyp_Pid, WireInst_Pid, Subcriber_List)
	end.

notify_subscribers([H | Tail], Msg) ->
	H ! Msg, 
	notify_subscribers(Tail, Msg);



notify_subscribers([], _ ) -> ok. 


