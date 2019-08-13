%% Feel free to use, reuse and abuse the code in this file.

%% @doc Handler with basic HTTP authorization.
-module(piPing).

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
	Respons = net_adm:ping('pi@192.168.0.108'),
	Respons,
	P = "{\"Respons is\": \"" ++ atom_to_list(Respons) ++ "\"}",
	Body = P,
	{Body,Req,User}.









