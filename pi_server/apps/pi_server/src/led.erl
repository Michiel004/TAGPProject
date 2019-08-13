-module(led).
-export([start_circuit/0,loop/0,ledBlueOn/0,ledBlueOff/0]).

start_circuit() ->
        Pid = spawn(led, loop, []),
        register(ontvanger, Pid),
        {ok, Gpio26} = gpio:start_link(26, output),
        {ok, Gpio20} = gpio:start_link(20, input),
        register(led1, Gpio26),
        register(led1Input, Gpio20),
	{ok, Gpio19} = gpio:start_link(19, output),
        {ok, Gpio16} = gpio:start_link(16, input),
	register(led2, Gpio19),
        register(led2Input, Gpio16),
        {ok, R1} = i2c:start_link("i2c-1", 16#6b),
        register(r1, R1),
      %	T = ets:new(config, [public]),
      %	ledstatusDT:start(),
	%ets:insert(T, {statusLeds, faild}),
      %	ledstatusDT:setStatus({statusLeds},faild),
	{ok, R2} = i2c:start_link("i2c-1", 16#08),
	register(r2, R2),
        loop.

loop() ->
        receive
        {bericht, on} ->
         gpio:write(led, 1),
         loop();
	{dtStatus,led,Respons} ->
	% ledstatusDT:updateStatus({statusLeds},Respons),
	 Respons,
	 loop();
        {bericht, off} ->
          gpio:write(led, 0),
          loop();
        {bericht,ison,Afzender} ->
         Status = gpio:read(ledInput),
         Afzender ! {antwoord, ison, Status},
         loop();
        {bericht, ledRedOff} ->
          i2c:write(r1, <<16#0D, 16#00>>),
          loop();
         {bericht, ledRedOn} ->
         i2c:write(r1, <<16#0D, 16#01>>),
          loop();
         {bericht, ledBlueOn} ->
          i2c:write(r1, <<16#0C, 16#01>>),
          loop();
         {bericht, ledBlueOff} ->
          i2c:write(r1, <<16#0C, 16#00>>),
          loop();
         {led, 1, isCurrent,Afzender} ->
	 Reg = i2c:read(r2, 3),
         <<ADC1,_,_>> = Reg,
        Afzender ! {antwoord, led, 1, isCurrent,ADC1},
        io:format("ADC1 is   ~p~n",[ADC1]),
         loop();
	{led, 2, isCurrent,Afzender} ->
         Reg = i2c:read(r2, 3),
         <<_,ADC2,_>> = Reg,
	 io:format("ADC2 is   ~p~n",[ADC2]),
        Afzender ! {antwoord, led, 2, isCurrent,ADC2},
         loop();
	{zp, 1, isCurrent,Afzender} ->
         Reg = i2c:read(r2, 3),
         <<_,_,ADC3>> = Reg,
	 io:format("ADC3 is   ~p~n",[ADC3]),
        Afzender ! {antwoord, zp, 1, isCurrent,ADC3},
         loop();
	{led, 1, on} ->
         gpio:write(led1, 1),
         loop();
	 {led, 1, off} ->
         gpio:write(led1, 0),
         loop();
        {led, 2, on} ->
         gpio:write(led2, 1),
         loop();
        {led, 2, off} ->
         gpio:write(led2, 0),
         loop();
	{led, 1, isOn , Afzender} ->
	 Status = gpio:read(led1Input),
         Afzender ! {antwoord,led1, ison, Status},
         loop();
	{led, 2, isOn , Afzender} ->
         Status = gpio:read(led2Input),
         Afzender ! {antwoord,led2, ison, Status},
         loop();
	{statusLeds,Afzender} ->
        Value =  ledstatusDT:getStatus({statusLeds}),
        Afzender ! {antwoord, leds, status,Value},
        %io:format("bericht 2  ~p~n",[1]),
         loop();
	 {led, 4, isCurrent,Afzender} ->
         AdcValue = adc:getValue(),
        Afzender ! {antwoord, led, 1, isCurrent,AdcValue},
        %io:format("bericht 2  ~p~n",[1]),
         loop();

        X ->
         io:format("onbekend bericht 2  ~p~n",[X]),
         loop()
        end.

ledBlueOn() ->
        self() ! {bericht, ledBlueOn}.

ledBlueOff() ->
        self() ! {bericht, ledBlueOff}.

