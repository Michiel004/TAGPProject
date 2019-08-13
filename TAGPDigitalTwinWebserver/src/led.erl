-module(led).
-export([start_ontvanger/0,loopo/0,loopz/0,start_zenderon/2,start_zenderon/1,on/0,off/0,status/0]).
start_ontvanger() ->
        Pid = spawn(distrib_test, loopo, []),
        register(ontvanger, Pid),
        Pid.

loopo() ->
        receive
        {bericht, on, Afzender} ->
          io:format("bericht ~p ontvangen van ~p~n led is on /n", [1, Afzender]),
          Afzender ! {antwoord, on, self()},
          loopo();
        {bericht, off, Afzender} ->
          io:format("bericht ~p ontvangen van ~p~n led is off /n", [1, Afzender]),
          Afzender ! {antwoord, off, self()},
          loopo();
        X ->
         io:format("onbekend bericht ~p~n",[X]),
         loopo()
        end.

start_zenderon(on, Node) ->
        Pid = spawn(led, loopz, []),
        [ {ontvanger,Node} ! {bericht, ison , Pid}].

start_zenderon(Node) ->
        [ {ontvanger,Node} ! {bericht, off, self()}].

loopz() ->
        receive
        {antwoord, on, Afzender} ->
         io:format("antwoord ~p ontvangen van ~p~nled is on ", [1, Afzender]),
          loopz();
        {antwoord, off, Afzender} ->
         io:format("antwoord ~p ontvangen van ~p~nled is off", [1, Afzender]),
        loopz();
	{antwoord,ison, Waarde} ->
         io:format("antwoord halo ~p ", [ Waarde]),
        loopz();
        X ->
         io:format("Er ging iets mis ~p~n",[X]),
         loopz()
         end.

on() ->
        [ {ontvanger,'pi@192.168.0.108'} ! {bericht, on}].

off() ->
        [ {ontvanger,'pi@192.168.0.108'} ! {bericht, off}].

status() ->
        [ {ontvanger,'pi@192.168.0.108'} ! {bericht, off}].









