/**
 * Setup gammeode defaults
 * And create startup resources (spawn cars/etc.)
 */
local script = "Empire Bay Death Match";

function scriptInit()
{
    log( script + " Loaded!" );
    setGameModeText( "EB-DM" );
    setMapName( "Empire Bay" );
    setSummer(false);
    setWeather("DT03part03MariaAgnelo");

    // Create cars surrounding the spawn bar.
    createVehicle(1, -1567.36, -193.678, -20.1856, -92.0449, 0.223556, 3.04026);
    createVehicle(8, -1546.6, -156.406, -19.2969, -0.241408, 2.89541, -2.29698);
    createVehicle(9, -1537.77, -168.93, -19.4142, 0.0217354, 0.396637, -2.80105);
    createVehicle(10, -1546.66, -181.15, -20.1519, 179.887, 3.31208, -0.653084);
}
addEventHandler( "onScriptInit", scriptInit );


/**
 * Add hanlding of player events
 * (player connections/disconnections/spawning)
 */
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

    sendPlayerMessage(playerid, "Welcome to Mafia2-Online Official Test Server!", 150, 150, 230);
    sendPlayerMessage(playerid, "You can test there some of the features :p", 150, 150, 230);
    sendPlayerMessage(playerid, "For help use command /help", 204, 255, 0);

    triggerClientEvent( playerid, "serverEvent", script, "a test string" );
}
addEventHandler( "onPlayerSpawn", playerSpawn );

/**
 * Demo of server-client-server event binding
 * and triggering
 */
addEventHandler( "eventConfirm",
    function( playerid )
    {
        givePlayerWeapon( playerid, 10, 2500 );
        givePlayerWeapon( playerid, 11, 2500 );
        givePlayerWeapon( playerid, 12, 2500 );
    }
);

/**
 * Hanling of various player events
 */
function playerDeath( playerid, killerid )
{
    if( killerid != INVALID_ENTITY_ID )
        sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has been killed by " + getPlayerName( killerid ) + ".", 255, 204, 0 );
    else
        sendPlayerMessageToAll( "~ " + getPlayerName( playerid ) + " has died.", 255, 204, 0 );
}
addEventHandler( "onPlayerDeath", playerDeath );


/**
 * Adding command handlers
 */
addCommandHandler("help", function(playerid) {
    local commands = [
        { name = "/spawn",          desc = "Teleport to spawn" },
        { name = "/weapons",        desc = "Give yourself some damn guns!" },
        { name = "/heal",           desc = "Restore your precious health points :p"},
        { name = "/die",            desc = "If you dont wanna live there anymore" },
        { name = "/vehicle <id>",   desc = "Spawn vehicle, example /vehicle 45" },
        { name = "/tune",           desc = "Tune up your vehicle!" },
        { name = "/fix",            desc = "Fix up your super vehicle" },
        { name = "/destroyVehicle", desc = "Remove car you are in" },
        { name = "/skin <id>",      desc = "Change your skin :O. Example: /skin 63" }
    ];

    sendPlayerMessage(playerid, "");
    sendPlayerMessage(playerid, "==================================", 200, 100, 100);
    sendPlayerMessage(playerid, "Here is list of available commands:", 200, 200, 0);

    foreach (idx, cmd in commands) {
        local text = " * Command: " + cmd.name + "   -   " + cmd.desc;
        if ((idx % 2) == 0) {
            sendPlayerMessage(playerid, text, 200, 230, 255);
        } else {
            sendPlayerMessage(playerid, text);
        }
    }
});

addCommandHandler("paint", function(playerid, r, g, b) {
    if (isPlayerInVehicle(playerid)) {
        local vehicle = getPlayerVehicle(playerid);

        if (!r) r = 255;
        if (!g) g = 255;
        if (!b) b = 255;

        setVehicleColour(vehicle, r.tointeger(), g.tointeger(), b.tointeger(), 255, 255, 255);
    }
});

addCommandHandler("tptome", function(playerid, pttpid) {
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

addCommandHandler("spawn", function(playerid) {
    setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
    setPlayerHealth( playerid, 720.0 );
});

addCommandHandler("weapons", function(playerid) {
    givePlayerWeapon( playerid, 10, 2500 );
    givePlayerWeapon( playerid, 11, 2500 );
    givePlayerWeapon( playerid, 12, 2500 );
});

local playerVehicles = {};

addCommandHandler("vehicle", function( playerid, id ) {
    local pos = getPlayerPosition( playerid );
    local rot = getPlayerRotation( playerid );

    if (playerid in playerVehicles) {
        sendPlayerMessage(playerid, "Removing your old car, and creating new one :)");
        destroyVehicle(playerVehicles[playerid]);
    }

    playerVehicles[playerid] <- createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, rot[1], 0.0 );
});

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    if (playerid in playerVehicles) {
        destroyVehicle(playerVehicles[playerid]);
        delete playerVehicles[playerid];
    }
});

addCommandHandler("tune", function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehicleTuningTable( vehicleid, 3 );

        setVehicleWheelTexture( vehicleid, 0, 11 );
        setVehicleWheelTexture( vehicleid, 1, 11 );
    }
});

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

addCommandHandler("savepos", function(playerid, ...) {
    // for info about reading modes check out
    // http://www.cplusplus.com/reference/cstdio/fopen/
    local posfile = file("positions.txt", "a");
    local pos;

    if (isPlayerInVehicle(playerid)) {
        pos = getVehiclePosition( getPlayerVehicle(playerid) );
    } else {
        pos = getPlayerPosition( playerid );
    }

    // read rest of the input string (if there any)
    // concat it, and push to the pos array
    if (vargv.len() > 0) {
        pos.push(vargv.reduce(function(a, b) {
            return a + " " + b;
        }));
    }

    // iterate over px,y,z]
    foreach (idx, value in pos) {

        // convert value to string,
        // and iterate over each char
        local coord = value.tostring();
        for (local i = 0; i < coord.len(); i++) {
            posfile.writen(coord[i], 'b');
        }

        // also write whitespace after the number
        posfile.writen(' ', 'b');
    }

    // and dont forget push newline before closing
    posfile.writen('\n', 'b');
    posfile.close();

    sendPlayerMessage(playerid, "You've saved current position; Check positions.txt near your server .exe")
});
