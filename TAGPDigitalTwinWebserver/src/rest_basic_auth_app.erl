%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(rest_basic_auth_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/test", testauth, []},
			{"/sun", sun, []},
			{"/piPing", piPing, []},
			{"/ledStatusOn", ledStatusOn, []},
			{"/ledStatusOff", ledStatusOff, []},
			{"/dtStatus", dtStatus, []},
			{"/supervisorStatus", getSupervisorStatus, []},
			{"/ledRedOn", ledRedOn, []},
			{"/ledRedOff", ledRedOff, []},
			{"/ledBlueOn", ledBlueOn, []},
			{"/ledBlueOff", ledBlueOff, []},
			{"/", toppage_h, []}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
	supervisorDT:start(),
	rest_basic_auth_sup:start_link().
	

stop(_State) ->
	ok.



