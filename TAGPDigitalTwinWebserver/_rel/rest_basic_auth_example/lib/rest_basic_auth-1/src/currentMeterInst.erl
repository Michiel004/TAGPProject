-module(currentMeterInst).
-export([create/4, init/4, estimate_flow/1, measure_flow/1,getTotalres/1]).
% -export([commission/1, activate/1]).
% -export([deactivate/1, decommission/1]).

% FlowMeter is a pipe and possibly a more complex resource;  
% this resource instance is passed to the create function.
% RealWorldCmdFn is a function to read out the real-world flowMeter. 

create(Host, FlowMeterTyp_Pid, PipeInst_Pid, RealWorldCmdFn) -> 
	{ok, spawn(?MODULE, init, [Host, FlowMeterTyp_Pid, PipeInst_Pid, RealWorldCmdFn])}.

init(Host, FlowMeterTyp_Pid, PipeInst_Pid, RealWorldCmdFn) -> 
	{ok, State} = resource_type:get_initial_state(FlowMeterTyp_Pid, Host, {PipeInst_Pid, RealWorldCmdFn}),

	wireInst:adapt_connectors(PipeInst_Pid, self()),
	wireInst:adapt_locations(PipeInst_Pid, self()),

	survivor:entry({ currentMeterInst_created, State }),
	loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid).

estimate_flow(FlowMeterInst_Pid) ->
	msg:get(FlowMeterInst_Pid, estimate_flow). 

measure_flow(FlowMeterInst_Pid) ->
	msg:get(FlowMeterInst_Pid, measure_flow).  

getTotalres(FlowMeterInst_Pid) ->
	msg:get(FlowMeterInst_Pid, getTotalres).  


loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid) -> 
	receive
		{measure_flow, ReplyFn} -> 
			{ok, Answer} = msg:get(FlowMeterTyp_Pid, measure_flow, State), 
			ReplyFn(Answer), 
			loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid);
		{estimate_flow, ReplyFn} -> 
			FlowMeterTyp_Pid ! {estimate_flow, State, ReplyFn}, 
			loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid);
		{getTotalres, ReplyFn} -> 
			FlowMeterTyp_Pid ! {getTotalres, State, ReplyFn}, 
			loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid);
		{get_type, ReplyFn} -> 
			ReplyFn(FlowMeterTyp_Pid),
			loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid);		
		OtherMessage -> 
			PipeInst_Pid ! OtherMessage,
			loop(Host, State, FlowMeterTyp_Pid, PipeInst_Pid)
	end.





