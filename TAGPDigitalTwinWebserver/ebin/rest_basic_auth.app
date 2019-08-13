{application, 'rest_basic_auth', [
	{description, "Cowboy Basic HTTP Authorization example"},
	{vsn, "1"},
	{modules, ['connector','currentMeterInst','currentMeterStatus','currentMeterTyp','currentStatus','digitalTwinLed','digitalTwinSolarPanel','dtStatus','fluidumInst','fluidumTyp','getSupervisorStatus','led','ledBlueOff','ledBlueOn','ledLoger','ledRedOff','ledRedOn','ledStatus','ledStatusOff','ledStatusOn','ledstatusDT','location','msg','piPing','powerDissipationInst','powerDissipationTyp','powerSourceInst','powerSourceTyp','powerSourceType','resource_instance','resource_type','rest_basic_auth_app','rest_basic_auth_sup','simpleElectricalCircuit_instance','simpleElectricalCircuit_type','solarPanelStatus','sun','sunStatus','supervisorDT','supervisorStatus','survivor','survivor2','survivorGpio','survivorUser','testauth','toppage_h','wireInst','wireTyp']},
	{registered, [rest_basic_auth_sup]},
	{applications, [kernel,stdlib,cowboy,hackney,jsx]},
	{mod, {rest_basic_auth_app, []}},
	{env, []}
]}.