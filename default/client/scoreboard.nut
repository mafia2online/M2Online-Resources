// scoreboard.nut By AaronLad

// Variables
local drawScoreboard = false;
local screenSize = getScreenSize( );

// Scoreboard math stuff
local fPadding = 5.0, fTopToTitles = 25.0;
local fWidth = 600.0, fHeight = ((fPadding * 2) + (fTopToTitles * 3));
local fOffsetID = 50.0, fOffsetName = 450.0;
local fPaddingPlayer = 20.0;
local fX = 0.0, fY = 0.0, fOffsetX = 0.0, fOffsetY = 0.0;

function tabDown()
{
	drawScoreboard = true;
	showChat( false );
			
	// Add padding to the height for each connected player
	for( local i = 0; i < MAX_PLAYERS; i++ )
	{
		if( isPlayerConnected(i) )
			fHeight += fPaddingPlayer;
	}
}
bindKey( "tab", "down", tabDown );

function tabUp()
{
	drawScoreboard = false;
	showChat( true );
			
	// Reset the height
	fHeight = ((fPadding * 2) + (fTopToTitles * 3));
}
bindKey( "tab", "up", tabUp );

function playerConnect( playerid, nickname )
{
	// Are we rendering the scoreboard?
	if( drawScoreboard )
		fHeight += fPaddingPlayer;
}
addEventHandler( "onClientPlayerConnect", playerConnect );

function playerDisconnect( playerid )
{
	// Are we rendering the scoreboard?
	if( drawScoreboard )
	{
		// Remove the height from this player
		fHeight = fHeight - fPaddingPlayer;
	}
}
addEventHandler( "onClientPlayerDisconnect", playerDisconnect );

function deviceReset()
{
	// Get the new screen size
	screenSize = getScreenSize();
}
addEventHandler( "onClientDeviceReset", deviceReset );

function frameRender( post_gui )
{
	if( post_gui && drawScoreboard )
	{
		fX = ((screenSize[0] / 2) - (fWidth / 2));
		fY = ((screenSize[1] / 2) - (fHeight / 2));
		fOffsetX = (fX + fPadding);
		fOffsetY = (fY + fPadding);
		
		dxDrawRectangle( fX, fY, fWidth, fHeight, fromRGB( 0, 0, 0, 128 ) );

		fOffsetX += 25.0;
		fOffsetY += 25.0;
		dxDrawText( "ID", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

		fOffsetX += fOffsetID;
		dxDrawText( "Nickname", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );
		
		fOffsetX += fOffsetName;
		dxDrawText( "Ping", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );
		
		// Draw the localplayer
		fOffsetX = (fX + fPadding + 25.0);
		fOffsetY += 20.0;
		dxDrawText( getLocalPlayer().tostring(), fOffsetX, fOffsetY, getPlayerColour(getLocalPlayer()), true, "tahoma-bold" );
		
		fOffsetX += fOffsetID;
		dxDrawText( getPlayerName(getLocalPlayer()), fOffsetX, fOffsetY, getPlayerColour(getLocalPlayer()), true, "tahoma-bold" );
		
		fOffsetX += fOffsetName;
		dxDrawText( getPlayerPing(getLocalPlayer()).tostring(), fOffsetX, fOffsetY, getPlayerColour(getLocalPlayer()), true, "tahoma-bold" );
		
		// Draw remote players
		for( local i = 0; i < MAX_PLAYERS; i++ )
		{
			if( i != getLocalPlayer() )
			{
				if( isPlayerConnected(i) )
				{
					fOffsetX = (fX + fPadding + 25.0);
					fOffsetY += fPaddingPlayer;
					dxDrawText( i.tostring(), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );
					
					fOffsetX += fOffsetID;
					dxDrawText( getPlayerName(i), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );
					
					fOffsetX += fOffsetName;
					dxDrawText( getPlayerPing(i).tostring(), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );
				}
			}
		}
	}
}
addEventHandler( "onClientFrameRender", frameRender );