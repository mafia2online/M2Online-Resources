local script = "Empire Bay Death Match";

function scriptInit()
{
	log( script + " Loaded!" );
	setGameModeText( "EBDM" );
	setMapName( "Empire Bay" );

	// Create cars surrounding the spawn bar.
	createVehicle(1, -1567.36, -193.678, -20.1856, -92.0449, 0.223556, 3.04026);
	createVehicle(8, -1546.6, -156.406, -19.2969, -0.241408, 2.89541, -2.29698);
	createVehicle(9, -1537.77, -168.93, -19.4142, 0.0217354, 0.396637, -2.80105);
	createVehicle(10, -1546.66, -181.15, -20.1519, 179.887, 3.31208, -0.653084);
}
addEventHandler( "onScriptInit", scriptInit );

function playerConnect( playerid, name, ip, serial )
{
	sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has joined the server.", 255, 204, 0 );
}
addEventHandler( "onPlayerConnect", playerConnect );

function playerDisconnect( playerid, reason )
{
	sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has left the server. (" + reason + ")", 255, 204, 0 );
}
addEventHandler( "onPlayerDisconnect", playerDisconnect );

function playerSpawn( playerid )
{
	setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
	setPlayerHealth( playerid, 720.0 );

	sendPlayerMessage( playerid, "Welcome to " + script );
	
	triggerClientEvent( playerid, "serverEvent", script, "a test string" );
}
addEventHandler( "onPlayerSpawn", playerSpawn );

addEventHandler( "eventConfirm",
	function( playerid )
	{
		givePlayerWeapon( playerid, 10, 2500 );
		givePlayerWeapon( playerid, 11, 2500 );
		givePlayerWeapon( playerid, 12, 2500 );
	}
);

function playerDeath( playerid, killerid )
{
	if( killerid != INVALID_ENTITY_ID )
		sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has been killed by " + getPlayerName( killerid ) + ".", 255, 204, 0 );
	else
		sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has died.", 255, 204, 0 );
}
addEventHandler( "onPlayerDeath", playerDeath );

addCommandHandler("tptome", function(playerid, pttpid)
{
	if (!pttpid) {
		sendPlayerMessage(playerid, "/tptome <pttpid>");
		return;
	}

	local playerToTeleport = pttpid.tointeger();
	if (!isPlayerConnected(playerToTeleport)) {
		sendPlayerMessage(playerid, "Player with given id is not connected.");
		return;
	}

	local myPos = getPlayerPosition(playerid);
	setPlayerPosition(playerToTeleport, myPos[0], myPos[1], myPos[2]);
});

addCommandHandler("destroyAllCars", function(playerid)
{
	local vehicles = getVehicles();

	for (local i = 0; i < vehicles.len(); ++i) {
		destroyVehicle(i);
	}
});

addCommandHandler( "vehicle",
	function( playerid, id )
	{
		local pos = getPlayerPosition( playerid );
		local rot = getPlayerRotation( playerid );

		createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, rot[1], 0.0 );
	}
);

addCommandHandler("createVehiclePrint",
	function(playerid)
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			local pos = getVehiclePosition (vehicleid);
			local rot = getVehicleRotation (vehicleid);

			local scriptLine = "createVehicle("+getVehicleModel(vehicleid).tostring()+", "+pos[0].tostring()+", "+pos[1].tostring()+", "+pos[2].tostring()+", "+rot[0].tostring()+", "+rot[1].tostring()+", "+rot[2].tostring()+");";

			sendPlayerMessage(playerid, scriptLine);
			log(scriptLine);
		}
		else {
			sendPlayerMessage(playerid, "You must be in vehicle to use this command.");
		}
	}
);

addCommandHandler( "tune",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			setVehicleTuningTable( vehicleid, 3 );

			setVehicleWheelTexture( vehicleid, 0, 11 );
			setVehicleWheelTexture( vehicleid, 1, 11 );
		}
	}
);

addCommandHandler( "destroyVehicle",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			destroyVehicle( vehicleid );
		}
	}
);

addCommandHandler( "colTest",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			repairVehicle( vehicleid );
		}
	}
);
addCommandHandler( "fix",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			repairVehicle( vehicleid );
		}
	}
);

addCommandHandler( "heal",
	function( playerid )
	{
		setPlayerHealth( playerid, 720.0 );
	}
);

addCommandHandler( "skin",
	function( playerid, id )
	{
		setPlayerModel( playerid, id.tointeger() );
	}
);

addCommandHandler( "die",
    function( playerid )
    {
        setPlayerHealth( playerid, 0.0 );
    }
);