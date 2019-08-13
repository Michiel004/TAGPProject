%%%-------------------------------------------------------------------
%% @doc pi_server public API
%% @end
%%%-------------------------------------------------------------------

-module(pi_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    led:start_circuit(),
    pi_server_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
