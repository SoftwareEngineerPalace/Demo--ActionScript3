package com.A17zuoye.mobile.testANE333
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	public class TestANELib3 extends EventDispatcher
	{
		public var context:ExtensionContext;
		
		public function TestANELib3()
		{
			super();
			
			trace("[android] new");
			
			context = ExtensionContext.createExtensionContext("com.A17zuoye.mobile.jpushane", "");
			if (!context)
			{
				throw new Error("no extension");
			}
		}
		
		
		public function init():void
		{
			trace("[android] init");
			
			context.call("init");
			context.addEventListener(StatusEvent.STATUS, onVolumeChanged);
		}
		
		
		public function setVolume(v:Number):void
		{
			trace("[android] setVolume " + v);
			
			context.call("setVolume", v);
		}
		
		
		private function onVolumeChanged(event:StatusEvent):void
		{
			trace("[android] on volume changed " + event.level);
		}
		
	}
}