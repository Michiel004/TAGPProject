-module(digitalTwinLed).
-export([init/1, do/0, mkA/0, get_root/1, get_aggr/1,getTotalRes/1,getTotalCurrent/1,getFlow/0,getTotalCurrentv2/1]).
-export([flow/1]).

init(Number) ->
	Pid = spawn(?MODULE, flow, [Number]),
	ledstatusDT:setPidLink(Number,Pid),
	Pid.


do() -> ok.

mkA() -> register(digitalTwinLed, spawn(?MODULE, flow, [])).

get_root(C) ->
	C ! {get_root, self()},
	receive 
		L -> {ok, L}
		after 5000 -> {error, timed_out}
	end. 

get_aggr(C) -> 
	C ! {get_aggr, self()}, 
	receive 
		A -> {ok, A}
		after 5000 -> {error, timed_out}
	end.  

getTotalRes(PID) ->
		%[source,w1,ampMeter, w2, res,w3,led,w3],
		%{_,ResLed} = powerDissipationInst:get_resistance(led),
		%{_,ResRes} = powerDissipationInst:get_resistance(res),
		%{_,ReSource} = powerDissipationInst:get_resistance(source),
		%{_,ResW1} = wireInst:get_resistance(w1),
		%{_,ResW2} = wireInst:get_resistance(w2),
		%{_,ResW3} = wireInst:get_resistance(w3),
		%{_,ResW4 }= wireInst:get_resistance(w4),
		%{_,ResAmpMeter} = powerDissipationInst:get_resistance(ampMeter),
		%Respons = ResLed + ResRes + ReSource + ResW1 + ResW2 + ResW3 + ResW4 + ResAmpMeter,
		%CircuitList = [source,w1,ampMeter, w2, res,w3,led,w3],
		Respons = currentMeterInst:getTotalres(ampMeter),
		PID ! {totalRes, self(),Respons}.


getTotalCurrent(PID) ->
		%[source,w1,ampMeter, w2, res,w3,led,w3],
		%{_,ResLed} = powerDissipationInst:get_resistance(led),
		%{_,ResRes} = powerDissipationInst:get_resistance(res),
		%{_,ReSource} = powerDissipationInst:get_resistance(source),
		%{_,ResW1} = wireInst:get_resistance(w1),
		%{_,ResW2} = wireInst:get_resistance(w2),
		%{_,ResW3} = wireInst:get_resistance(w3),
		%{_,ResW4 }= wireInst:get_resistance(w4),
		%{_,ResAmpMeter} = powerDissipationInst:get_resistance(ampMeter),
		%Respons = ResLed + ResRes + ReSource + ResW1 + ResW2 + ResW3 + ResW4 + ResAmpMeter,
		%CircuitList = [source,w1,ampMeter, w2, res,w3,led,w3],
		Res = currentMeterInst:estimate_flow(ampMeter),
		 {_, Voltige} = powerSourceInst:get_voltige(source),
		 Respons = Voltige / Res,
		PID ! {totalCurrent, self(),Respons}.

%test1(Pid) ->
%	{_,Antwoord} = powerDissipationInst:get_resistance(Pid),
%	Antwoord.

getTotalCurrentv2(PID) ->
		%[source,w1,ampMeter, w2, res,w3,led,w3],
		{_,ResLed} = powerDissipationInst:get_resistance(led),
		{_,ResRes} = powerDissipationInst:get_resistance(res),
		{_,ReSource} = powerDissipationInst:get_resistance(source),
		{_,ResW1} = wireInst:get_resistance(w1),
		{_,ResW2} = wireInst:get_resistance(w2),
		{_,ResW3} = wireInst:get_resistance(w3),
		{_,ResW4 }= wireInst:get_resistance(w4),
		{_,ResAmpMeter} = powerDissipationInst:get_resistance(ampMeter),
		TotalRes = ResLed + ResRes + ReSource + ResW1 + ResW2 + ResW3 + ResW4 + ResAmpMeter,
		{_,VoltigeSource} = powerDissipationInst:get_voltige(source),
		Respons = VoltigeSource / TotalRes,
		PID ! {totalCurrent , ledRed,Respons}.

flow(Number) -> 
	% Digital twin voor led circuit created. 
	survivor:entry(digitalTwinLed_started),
	T = ets:new(config, [public]),
	%register(numer, Number),
	{ok, WT1} =  wireTyp:create(),
	
	%register(NameWT1, WT1),
	ets:insert(T, {wire_type_no1, WT1}),
	
	{ok, PowerDissipationT1} = powerDissipationTyp:create(),
	ets:insert(T, {powerDissipation_type_no1, PowerDissipationT1}),

	{ok, PowerSourceT1} = powerSourceTyp:create(),
	ets:insert(T, {powerDissipation_type_no1, PowerSourceT1}),

	{ok, FlowMeterT1} = currentMeterTyp:create(),
	ets:insert(T, {flowMeterTyp_no1, FlowMeterT1}), 
%-------------------------------------------
	% Digital twin of led 

	{ok, PI4powerDissipation} = wireInst:create(self(), WT1), 
	ets:insert(T, {led_instance_no1, PI4powerDissipation}),
	%timer:sleep(1000), 
    RWCmdFn = fun(Cmd) -> ets:insert(T, {powerDissipationCmd, Cmd, self()}) end,
	{ok, PidLed} = powerDissipationInst:create(self(), PowerDissipationT1, PI4powerDissipation, RWCmdFn), 
	ets:insert(T, {powerDissipation_instance_no1, PidLed}),
	%register(led, PI1),
	powerDissipationInst:set_resistance(PidLed,9999999999999),
	ledstatusDT:setStatus({led ,Number,status},off),
	ledstatusDT:setStatus({rwLed ,Number,status},0),


%-------------------------------------------
	% Digital twin of resistor 

	{ok, PI8resistor} = wireInst:create(self(), WT1), 
	ets:insert(T, {resistor_instance_no1, PI8resistor}),
	%timer:sleep(1000), 
    RWCmdFn3 = fun(Cmd) -> ets:insert(T, {powerDissipationCmd, Cmd, self()}) end,
	{ok, PIRes} = powerDissipationInst:create(self(), PowerDissipationT1, PI8resistor, RWCmdFn3), 
	ets:insert(T, {resistor_instance_no1, PIRes}),
	%register(res, PI8),
	powerDissipationInst:set_resistance(PIRes,330),
	ledstatusDT:setStatus({Number,resResistor},330),

%-------------------------------------------

% Digital twin of powerSource 

	{ok, PI5powerSource} = wireInst:create(self(), WT1), 
	ets:insert(T, {powerSource_instance_no1, PI5powerSource}),
	%timer:sleep(1000), 
    RWCmdFn2 = fun(Cmd) -> ets:insert(T, {powerSourceCmd, Cmd, self()}) end,
	{ok, PIsource} = powerSourceInst:create(self(), PowerSourceT1, PI5powerSource, RWCmdFn2), 
	ets:insert(T, {powerDissipation_instance_no1, PIsource}),
	ledstatusDT:setStatus({Number,sourceVoltige},3.3),
	%register(source, PI5),
	
%--------------------------------------------
	% Digital twin of current meter
	{ok, PI4FlowMeter} = wireInst:create(self(), WT1),
	ets:insert(T, {pipe_instance_no2, PI4FlowMeter}),
	%timer:sleep(1000), 
	{ok, PIampMeter} =  currentMeterInst:create(self(), FlowMeterT1, PI4FlowMeter,RWCmdFn2), 
	%register(ampMeter, PI2),
	ets:insert(T, {currentMeter_instance_no1, PIampMeter}),
	ledstatusDT:setStatus({Number,totalCurrent},0),
	ledstatusDT:setStatus({Number,rwTotalCurrent},0),
	ledstatusDT:setStatus({Number,totalCurrent},0),
%---------------------------------------------
	% Digital twin of wire
	{ok, PIw1} = wireInst:create(self(), WT1),
	%register(w1, PI3), 
	ets:insert(T, {wire_instance_no3, PIw1}),
	ledstatusDT:setStatus({Number,reswire1},0),

%---------------------------------------------
	% Digital twin of wire
	{ok, PIW2} = wireInst:create(self(), WT1),
	%register(w2, PI4), 
	ets:insert(T, {wire_instance_no4, PIW2}),
	ledstatusDT:setStatus({Number,reswire2},0),

	% Digital twin of wire
	{ok, PIW3} = wireInst:create(self(), WT1),
	%register(w3, PI6), 
	ets:insert(T, {wire_instance_no6, PIW3}),
	ledstatusDT:setStatus({Number,reswire3},0),

	% Digital twin of wire
	{ok, PIW4} = wireInst:create(self(), WT1),
	%register(w4, PI7), 
	ets:insert(T, {wire_instance_no6, PIW4}),
	ledstatusDT:setStatus({Number,reswire4},0),
%---------------------------------------------
	CircuitList = [PIsource,PIw1,PIampMeter, PIW2, PIRes,PIW3,PidLed,PIW4],
	survivorUser:entry({amoundPidsInCircuits, length(CircuitList)}),
	func([CircuitList]),
	%{ok, AggrTyp_Pid} = simpleElectricalCircuit_type:create(),
	%{ok, AggrInst_Pid} = simpleElectricalCircuit_instance:create(self(), AggrTyp_Pid, [PI5,PI3,PI2, PI4, PI8,PI6,PI1,PI7]),
	%survivorUser:entry({aggrInst_Pid, AggrInst_Pid}),
	survivorUser:entry({circuitListname,  [PIsource,PIw1,PIampMeter, PIW2, PIRes,PIW3,PidLed,PIW4]}),
	[survivorUser:entry({circuitListnamev2,  H}) || H <- CircuitList],
%---------------------------------------------	
	{ok, FluidumTyp_Pid} = fluidumTyp:create(),
	connectPipes(CircuitList),
	{ok, [Root_ConnectorPid | _ ]} = resource_instance:list_connectors(PidLed),
	survivor:entry({fluidumInstAbout2Bcreated, FluidumTyp_Pid, Root_ConnectorPid}),
	{ok, FluidumInst_Pid} = fluidumInst:create(Root_ConnectorPid, FluidumTyp_Pid),
	%timer:sleep(1000),
	fluidumInst:load_circuit(FluidumInst_Pid), 
	currendAvailable(CircuitList, FluidumInst_Pid), 
	%survivor:entry(currentMeterInst:estimate_flow(ampMeter)),
	loop(CircuitList, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes).

loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes) -> 
	receive 
		{get_root, Pid} -> 
			Any = aggregate_instance:get_root(AggrInst_Pid),
			Pid ! Any, 
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{get_aggr, Pid} -> 
			Pid ! AggrInst_Pid, 
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{led,on} -> 
			powerDissipationInst:switch_on(PidLed), 
			powerDissipationInst:set_resistance(PidLed,396),
			{ontvanger,'pi@192.168.0.108'} ! {led, numer, on},
			ledstatusDT:updateStatus({led ,Number,status},on),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{ledResistance, Value} -> 
			powerDissipationInst:set_resistance(PidLed,Value),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{resresistance, Value} -> 
			powerDissipationInst:set_resistance(res,Value),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{led,off} -> 
			powerDissipationInst:switch_off(PidLed), 
			{ontvanger,'pi@192.168.0.108'} ! {led, numer, off},
			ledstatusDT:updateStatus({led ,Number,status},off),
			powerDissipationInst:set_resistance(PidLed,9999999999999),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{led, isOn} -> 
			 {_, Respons} = powerDissipationInst:is_on(PidLed), 
			ledstatusDT:updateStatus(Respons),
			digitalTwinStatus:setStatus([led, status],Respons),
			ledstatusDT:updateStatus({rwLed ,Number,status},on),
			{ontvanger,'pi@192.168.0.108'} ! {led, numer, isOn , self()},
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{source, getVoltige} -> 
			 {_, Respons} = powerSourceInst:get_voltige(source), 
			digitalTwinStatus:setStatus([source, voltige],Respons),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{source, setVoltige} -> 
			powerSourceInst:set_voltige(source), 
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{total, current} -> 
			{ontvanger,'pi@192.168.0.108'} ! {led, Number, isCurrent,self()},
			{_, Res} = currentMeterInst:estimate_flow(PIampMeter),
		    {_, Voltige} = powerSourceInst:get_voltige(PIsource),
		    Respons = Voltige / Res,
			%ledstatusDT:setStatus({Number,rwTotalCurrent},Respons),
			ledstatusDT:updateStatus({Number,totalCurrent},Respons),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		{antwoord, led, Number, isCurrent,AdcValue} ->
			{_, Voltige} = powerSourceInst:get_voltige(PIsource),
			VoltigeAdc = AdcValue*Voltige/255,
			{_, Res} = powerDissipationInst:get_resistance(PIRes),
			Current = VoltigeAdc / Res,
			io:fwrite("current ~p~n", [Current]),
			ledstatusDT:updateStatus({Number,rwTotalCurrent},Current),
			loop(AggrInst_Pid, FluidumInst_Pid,PidLed,PIampMeter,PIsource,PIw1,PIW2,PIW3,Number,PIRes);
		stop -> ok
	end. 	


currendAvailable([H|Elements], CurrentPid) ->
	io:fwrite("Inserting current in wire ~p~n", [H]),
	{ok, [Location]} = resource_instance:list_locations(H),
	location:arrival(Location, CurrentPid),
	currendAvailable(Elements, CurrentPid);
currendAvailable([], _CurrentPid) -> ok.

getFlow() ->
	{ok, F} = currentMeterInst:estimate_flow(flowInst),
	F.

connectPipe(Pipe0, Pipe1) ->
	{ok, [_, Conn0Out]} = resource_instance:list_connectors(Pipe0),
	{ok, [Conn1In, _]}  = resource_instance:list_connectors(Pipe1),
	io:fwrite("Connecting ~p to ~p~n", [Pipe0, Pipe1]),
	connector:connect(Conn0Out, Conn1In),
	connector:connect(Conn1In, Conn0Out).

connectPipes([P0|[P1|List]]) ->
	connectPipe(P0, P1),
	connectPipes([P1|List], P0).
connectPipes([P0|[P1|List]], First) -> 
	connectPipe(P0, P1),
	connectPipes([P1|List], First);
connectPipes([Last], First) -> 
	connectPipe(Last, First),
	ok.

func([]) -> ok;
func([H|T]) ->
	survivor:entry({ditish, H}),
    func(T).







