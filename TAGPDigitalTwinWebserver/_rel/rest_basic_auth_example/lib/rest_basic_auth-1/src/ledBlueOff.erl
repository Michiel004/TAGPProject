-module(ledBlueOff).

-export([init/2]).
-export([content_types_provided/2]).
-export([is_authorized/2]).
-export([to_text/2]).


init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.

is_authorized(Req, State) ->
	case cowboy_req:parse_header(<<"authorization">>, Req) of
		{basic, User = <<"Michiel">>, <<"Erlang">>} ->
			{true, Req, User};
		_ ->
			{{false, <<"Basic realm=\"cowboy\"">>}, Req, State}
	end.

content_types_provided(Req, State) ->
	{[
		{<<"text/plain">>, to_text}
	], Req, State}.

to_text(Req, User) ->
	{ontvanger,'pi@192.168.0.108'} ! {bericht, ledBlueOff},
	
	P = "{\"Respons is\": \"" ++ "Led blue is off" ++ "\"}",
	Body = P,
	{Body,Req,User}.




