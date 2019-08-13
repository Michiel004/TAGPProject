-module(getSupervisorStatus).

-export([init/2]).
-export([content_types_provided/2]).
-export([is_authorized/2]).
-export([to_code/2]).


init(Req, Opts) ->
	{cowboy_rest, Req, Opts}.



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
    G = supervisorDT:getStatus(),
	Body = G,
	%Body = <<"{\"rest\": \"Hello World!\"}">>,
	{Body,Req,User}.