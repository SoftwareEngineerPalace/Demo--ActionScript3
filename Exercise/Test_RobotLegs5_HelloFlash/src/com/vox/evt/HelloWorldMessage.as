package com.vox.evt
{
	import flash.events.Event;
	
	public class HelloWorldMessage extends Event
	{
		public static const Ball_Clicked:String = "Ball_Clicked" ;
		public var body:* ;
		
		public function HelloWorldMessage(type:String,$body:*)
		{
			super(type);
			
			body = $body ;
		}
	}
}