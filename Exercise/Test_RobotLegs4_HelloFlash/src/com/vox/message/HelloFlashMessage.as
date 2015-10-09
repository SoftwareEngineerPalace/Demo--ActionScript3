package com.vox.message
{
	import flash.events.Event;
	
	public class HelloFlashMessage extends Event
	{
		public static const Ball_Clicked:String = "Ball_Clicked";
		
		public var body:* ;
		
		public function HelloFlashMessage( type:String )
		{
			super( type ) ;
		}
	}
}