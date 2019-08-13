-module(supervisorDT).
-export([start/0, init/0,getStatus/0,getStatusv2/0,led1On/0,led2On/0,led1Off/0,led2Off/0,led1GetTotalCurrent/0,led2GetTotalCurrent/0,getLed1Current/0,solarPanelGetTotalCurrent/0,setResCircuit2/1]). 
-export([getLed2Current/0]).
start() ->
    supervisorStatus:start(),
	currentMeterStatus:start(),
	observer:start(),
	survivorGpio:start(),
	survivorUser:start(),
	survivor:start(),
	ledstatusDT:start(),
	solarPanelStatus:start(),
	register(supervisorDT, spawn(?MODULE, init, [])).

init() -> 	
    	Pid1 = digitalTwinLed:init(1),
		Pid2 = digitalTwinLed:init(2),
		Pid3 = digitalTwinSolarPanel:init(1),
		register(zp, Pid3),
		register(ledRed, Pid1),
		register(ledGreen, Pid2),
		led1On(),
		setResCircuit2(220),
		led1GetTotalCurrent(),
		led2GetTotalCurrent(),
		solarPanelGetTotalCurrent(),
		supervisorStatus:setStatus({supervisorDT,tolerenceCurrentLed1},5),
		supervisorStatus:setStatus({supervisorDT,tolerenceCurrentLed2},5),
		timer:sleep(4000),
		Tolerence1 = supervisorStatus:getStatus({supervisorDT,tolerenceCurrentLed1}),
		Tolerence2 = supervisorStatus:getStatus({supervisorDT,tolerenceCurrentLed2}),
		TotalCurrentLed1Rw = ledstatusDT:getStatus({1,rwTotalCurrent}),
		TotalCurrentLed2Rw = ledstatusDT:getStatus({2,rwTotalCurrent}),
		TotalCurrentLed1 = ledstatusDT:getStatus({1,totalCurrent}),
		TotalCurrentLed2 = ledstatusDT:getStatus({2,totalCurrent}),

		TolerenceValue1 =  TotalCurrentLed1 / 100 * Tolerence1,
		TolerenceValue2 =  TotalCurrentLed2 / 100 * Tolerence2,

		ErrorCurrent1 = abs(TotalCurrentLed1Rw - TotalCurrentLed1),
		ErrorCurrent2 = abs(TotalCurrentLed2Rw - TotalCurrentLed2),

		TotalCurrentZPRW = solarPanelStatus:getStatus({1,rwTotalCurrent}),
		TotalCurrentZP = solarPanelStatus:getStatus({1,totalCurrent}),

		io:fwrite("test~p~n", [TotalCurrentZPRW]),
		io:fwrite("test2~p~n", [TotalCurrentZP]),

		if
		(ErrorCurrent1 =< TolerenceValue1) ->
   		supervisorStatus:setStatus({led1,totalCurrent},passed);
		true ->
   		supervisorStatus:setStatus({led1,totalCurrent},failed)
		end,

		if
		(ErrorCurrent2 =< TolerenceValue2) ->
   		supervisorStatus:setStatus({led2,totalCurrent},passed);
		true ->
   		supervisorStatus:setStatus({led2,totalCurrent},failed)
		end,

		if
		(TotalCurrentZP == up) ->
			if
			(TotalCurrentZPRW >= 125) ->
   			supervisorStatus:setStatus({zp1,totalCurrent},passed);
			true ->
   			supervisorStatus:setStatus({zp1,totalCurrent},failed)
			end;
		true ->
			if
			(TotalCurrentZPRW =< 125) ->
   			supervisorStatus:setStatus({zp1,totalCurrent},passed);
			true ->
   			supervisorStatus:setStatus({zp1,totalCurrent},failed)
			end
		end,

	
	loop().

loop() -> 
	receive
         {totalRes, Pid,Value} -> 
             supervisorStatus:setStatus({Pid,totalRes},Value),
			 loop();
		{totalCurrent, Pid,Value} -> 
             supervisorStatus:setStatus({Pid, totalCurrent},Value),
			 loop();
		{getStatus, Pid} -> 
            StatusLed1 =  supervisorStatus:getStatus({led1,totalCurrent}),
			StatusLed2 =  supervisorStatus:getStatus({led2,totalCurrent}),
			Respons = StatusLed1 + StatusLed2,
			Pid ! {status,Respons},
			 loop();
		 test -> 
             supervisorStatus:setStatus(test,{totalRes,ok}),
			 loop();
		stop -> ok
	end. 


getStatus() ->
		%digitalTwinLed:getTotalCurrent(supervisorDT),

	    led1GetTotalCurrent(),
		led2GetTotalCurrent(),
		solarPanelGetTotalCurrent(),
		timer:sleep(1000),
		Tolerence1 = supervisorStatus:getStatus({supervisorDT,tolerenceCurrentLed1}),
		Tolerence2 = supervisorStatus:getStatus({supervisorDT,tolerenceCurrentLed2}),
		TotalCurrentLed1Rw = ledstatusDT:getStatus({1,rwTotalCurrent}),
		TotalCurrentLed2Rw = ledstatusDT:getStatus({2,rwTotalCurrent}),
		TotalCurrentLed1 = ledstatusDT:getStatus({1,totalCurrent}),
		TotalCurrentLed2 = ledstatusDT:getStatus({2,totalCurrent}),

		TolerenceValue1 =  TotalCurrentLed1 / 100 * Tolerence1,
		TolerenceValue2 =  TotalCurrentLed2 / 100 * Tolerence2,

		ErrorCurrent1 = abs(TotalCurrentLed1Rw - TotalCurrentLed1),
		ErrorCurrent2 = abs(TotalCurrentLed2Rw - TotalCurrentLed2),

		TotalCurrentZPRW = solarPanelStatus:getStatus({1,rwTotalCurrent}),
		TotalCurrentZP = solarPanelStatus:getStatus({1,totalCurrent}),

		%io:fwrite("test~p~n", [TotalCurrentZPRW]),
		%io:fwrite("test2~p~n", [TotalCurrentZP]),

		if
		(ErrorCurrent1 =< TolerenceValue1) ->
   		supervisorStatus:setStatus({led1,totalCurrent},passed);
		true ->
   		supervisorStatus:setStatus({led1,totalCurrent},failed)
		end,

		if
		(ErrorCurrent2 =< TolerenceValue2) ->
   		supervisorStatus:setStatus({led2,totalCurrent},passed);
		true ->
   		supervisorStatus:setStatus({led2,totalCurrent},failed)
		end,

		if
		(TotalCurrentZP == up) ->
			if
			(TotalCurrentZPRW >= 200) ->
   			supervisorStatus:setStatus({zp1,totalCurrent},passed);
			true ->
   			supervisorStatus:setStatus({zp1,totalCurrent},failed)
			end;
		true ->
			if
			(TotalCurrentZPRW =< 200) ->
   			supervisorStatus:setStatus({zp1,totalCurrent},passed);
			true ->
   			supervisorStatus:setStatus({zp1,totalCurrent},failed)
			end
		end,

		X =  supervisorStatus:getStatus({led1,totalCurrent}),
		Y =  supervisorStatus:getStatus({led2,totalCurrent}),
		Z =  supervisorStatus:getStatus({zp1,totalCurrent}),
		P = "{\"LedCircuit1 has\": \"" ++ atom_to_list(X) ++ "\"LedCircuit2 has\": \"" ++ atom_to_list(Y) ++ "\"Circuit Solar Panel has\": \"" ++ atom_to_list(Z) ++ "\"}",
		P.

getStatusv2() ->
		digitalTwinLed:getTotalRes(supervisorDT),
        ok.

led1On() ->
	ledRed ! {led,on}.

led2On() ->
	ledGreen ! {led,on}.

led1Off() ->
	ledRed ! {led,off}.
led2Off() ->
	ledGreen ! {led,off}.
led1GetTotalCurrent() ->
	ledRed ! {total, current}.

led2GetTotalCurrent() ->
	ledGreen ! {total, current}.

getLed1Current() ->
		TotalCurrentLed1 = ledstatusDT:getStatus({1,rwTotalCurrent}),
		TotalCurrentLed1.
getLed2Current() ->
		TotalCurrentLed2 = ledstatusDT:getStatus({2,rwTotalCurrent}),
		TotalCurrentLed2.
solarPanelGetTotalCurrent() ->
		zp ! {total, current}.

setResCircuit2(Value) ->
		ledGreen ! {resresistance, Value}.






