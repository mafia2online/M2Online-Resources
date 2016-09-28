// fps.nut By AaronLad

addEventHandler( "onClientFrameRender", 
	function( post )
	{
		if( post )
			dxDrawText( "FPS: " + getFPS(), 2.0, 2.0, 0xFFFFFFFF, true, "tahoma-bold" );
	}
)