-module(adc).
-export([getValue/0]).

getValue() ->
	Bit1 = sim:get(1),
	Bit2 = sim:get(1),
	Bit3 = sim:get(1),
	Bit4 = sim:get(1),
	Bit5 = sim:get(1),
	Bit6 = sim:get(1),
	Bit7 = sim:get(1),
        Bit8 = sim:get(1),

	if
        Bit1==1 ->
         Value1 =  1;
        true ->
         Value1 =  0
        end,

	if
        Bit2==1 ->
         Value2 =  2;
        true ->
         Value2 =  0
        end,

	if
        Bit3==1 ->
         Value3 =  4;
        true ->
         Value3 =  0
         end,

	if
        Bit4==1 ->
         Value4 =  8;
        true ->
         Value4 =  0
         end,

	if
        Bit5==1 ->
         Value5 =  16;
        true ->
         Value5 =  0
         end,

	if
        Bit6==1 ->
         Value6 =  32;
        true ->
         Value6 =  0
         end,

	if
        Bit7==1 ->
         Value7 =  64;
        true ->
         Value7 =  0
         end,

	if
        Bit8==1 ->
         Value8 =  128;
        true ->
         Value8 =  0
         end,

	 Value = Value1 + Value2 + Value3 + Value4 + Value5 + Value6 + Value7 + Value8,
	 Value.
        
