-module(currentMeterTyp).
-export([create/0, init/0, computeFlow/1]).
% -export([dispose/2, enable/2, new_version/2]).
% -export([get_initial_state/3, get_connections_list/2]). % use resource_type
% -export([update/3, execute/7, refresh/4, cancel/4, update/7, available_ops/2]). 

create() -> {ok, spawn(?MODULE, init, [])}.

init() -> 
	survivor:entry(currentMeterTyp_created),
	loop().

loop() -> 
	receive
		{initial_state, {MeterInst_Pid, {ResInst_Pid, RealWorldCmdFn}}, ReplyFn} ->
			{ok, [L | _ ] } = resource_instance:list_locations(ResInst_Pid),
			{ok, Fluidum} = location:get_Visitor(L),
			ReplyFn(#{meterInst => MeterInst_Pid, resInst => ResInst_Pid, 
					  fluidum => Fluidum, rw_cmd => RealWorldCmdFn,totalres => 0}), 
			loop();
		{measure_flow, State, ReplyFn} -> 
			#{rw_cmd := ExecFn} = State,
			ReplyFn(ExecFn()),
			loop(); 
		{getTotalres, State, ReplyFn} -> 
			#{totalres := Value} = State,
			ReplyFn(Value),
			loop(); 
		{estimate_flow, State, ReplyFn} -> 
			%ReplyFn(State#{totalres := [test1(H) || H <- Circuit]}),
			%#{totalres := ExecFn} = State, ExecFn(25), 
			%ReplyFn(State#{totalres := ExecFn}),
			#{resInst := ResInst_Pid} = State,
			%#{totalres := ResistanceVaulue} = State, 
			%ReplyFn(State#{totalres :=  ResistanceVaulue + 5}),
			{ok, [L | _ ] } = resource_instance:list_locations(ResInst_Pid),
			{ok, Fluidum} = location:get_Visitor(L), 
			 %ReplyFn(Fluidum),
			 {ok, C} = fluidumInst:get_resource_circuit(Fluidum),
			% ReplyFn(C), 
			survivor:entry({estimateflow, for, C}), 
			P = maps:to_list(C),
			currentMeterStatus:setStatus({ResInst_Pid,totalRes},0),
			[test1(H,ResInst_Pid) || H <- P],
			Newres = currentMeterStatus:getStatus({ResInst_Pid,totalRes}),
			%ledstatusDT:setStatus({1,rwTotalCurrent},1),
			ReplyFn(Newres),
			loop()
	end. 

test1(P,P2) ->
	%{_,Antwoord} = powerDissipationInst:get_resistance(Pid),
	{Pid,_} = P, 
	Oldvalue = currentMeterStatus:getStatus({P2,totalRes}),
	{_,ResRes} = powerDissipationInst:get_resistance(Pid),
	NewValue = Oldvalue + ResRes,
	currentMeterStatus:setStatus({P2,totalRes},NewValue),
	survivor:entry({test1, NewValue}).

computeFlow(ResCircuit) -> 
 	Interval = {0, 10}, % ToDo >> discover upper bound for flow.
	{ok, InfluenceFnCircuit} = influence(maps:next(maps:iterator(ResCircuit)), []),
	survivor:entry({isthisapid, InfluenceFnCircuit}),
	%test1(InfluenceFnCircuit),
	compute(Interval, InfluenceFnCircuit).

influence({C, _ , Iter }, Acc) ->
		{ok, InflFn} = apply(resource_instance, get_flow_influence, [C]),
		influence(maps:next(Iter), [ InflFn | Acc ] );

influence(none, Acc) -> {ok, Acc}. 

compute({Low, High}, _InflFnCircuit) when (High - Low) < 1 -> 
	%Todo convergentiewaarde instelbaar maken. 
	(Low + High) / 2 ;
	
compute({Low, High}, InflFnCircuit) ->
	L = eval(Low, InflFnCircuit, 0),
	H = eval(High, InflFnCircuit, 0),
	L = eval(Low, InflFnCircuit, 0),
	H = eval(High, InflFnCircuit, 0),
	Mid = (H + L) / 2, M = eval(Mid, InflFnCircuit, 0),
	if 	M > 0 -> 
			compute({Low, Mid}, InflFnCircuit);
        true -> % works as an 'else' branch
            compute({Mid, High}, InflFnCircuit)
    end.

	
eval(Flow, [Fn | RemFn] , Acc) ->
	%survivor:entry({test1, Fn}),
	%test1(Fn),






	eval(Flow, RemFn, Acc + Fn(Flow));

eval(_Flow, [], Acc) -> Acc. 
