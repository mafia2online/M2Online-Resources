// events.nut By AaronLad

addEventHandler( "serverEvent",
	function( script, str )
	{
		triggerServerEvent( "eventConfirm" );
	}
);