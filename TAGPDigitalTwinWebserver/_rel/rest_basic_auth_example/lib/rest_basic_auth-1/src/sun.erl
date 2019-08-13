%% Feel free to use, reuse and abuse the code in this file.

%% @doc Handler with basic HTTP authorization.
-module(sun).

-export([init/2]).
-export([content_types_provided/2]).
-export([is_authorized/2]).
-export([to_code/2]).


init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

loop(Ref) ->
    receive
        {hackney_response, Ref, {status, StatusInt, Reason}} ->
            io:format("got status: ~p with reason ~p~n", [StatusInt,Reason]),
            loop(Ref);
        {hackney_response, Ref, {headers, Headers}} ->
            io:format("got headers: ~p~n", [Headers]),
            loop(Ref);
        {hackney_response, Ref, done} ->
            ok;
        {hackney_response, Ref, Bin} ->
            %io:format("got chunk: ~p~n", [Bin]),
	    %file:write_file("/tmp/foo", io_lib:fwrite("~p.\n", [Bin])),
	    Data = jsx:decode(Bin),
    	    %io:format("got Data: ~p~n", [Data]),
            Sys = proplists:get_value(<<"sys">>, Data),
            %io:format("got Sys: ~p~n", [Sys]),
            Sunrise = proplists:get_value(<<"sunrise">>, Sys), 
            %io:format("got Sunrise: ~p~n", [Sunrise]),
            Sunset = proplists:get_value(<<"sunset">>, Sys), 
            %io:format("got Sunset: ~p~n", [Sunset]),
            {MegaSecs, Secs, _} = erlang:timestamp(),
            %io:format("got MicroSecs: ~p~n", [MicroSecs]),
            UnixTime = MegaSecs * 1000000 + Secs,
           % io:format("got Now: ~p~n", [UnixTime]),
	    
		if Sunrise < UnixTime ->
		  if UnixTime < Sunset ->
			up;
      		true -> 
        	down
   		end;
      		true -> 
        	down
   		end;
            %loop(Ref);

        Else ->
            io:format("else ~p~n", [Else]),
            ok
    end.



is_authorized(Req, State) ->
	case cowboy_req:parse_header(<<"authorization">>, Req) of
		{basic, User = <<"Michiel">>, <<"Erlang">>} ->
			{true, Req,User};
		_ ->
			{{false, <<"Basic realm=\"cowboy\"">>}, Req, State}
	end.

content_types_provided(Req, State) ->
	{[
		{<<"text/plain">>, to_code}
	], Req, State}.
to_code(Req,User) ->
	application:ensure_all_started(hackney),
    	Url = <<"https://openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22">>,
    	Opts = [async],
    	{ok, Ref} = hackney:get(Url, [], <<>>, Opts),
    	G = loop(Ref),
	io:format("got Sunset: ~p~n", [G]),
	P = "{\"Sun is\": \"" ++ atom_to_list(G) ++ "\"}",
	Body = P,
	%Body = <<"{\"rest\": \"Hello World!\"}">>,
	{Body,Req,User}.




