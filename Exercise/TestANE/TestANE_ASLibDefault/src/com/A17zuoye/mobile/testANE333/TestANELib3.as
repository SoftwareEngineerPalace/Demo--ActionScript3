package com.A17zuoye.mobile.testANE333
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;

	public class TestANELib3 extends EventDispatcher
	{
		public function TestANELib3()
		{
			super();
			
			trace("[default] new");
		}
		
		
		public function init():void
		{
			trace("[default] init");
		}
		
		
		public function setVolume(v:Number):void
		{
			trace("[default] setVolume " + v);
		}
		
		
		private function onVolumeChanged(event:StatusEvent):void
		{
		}
		
	}
}