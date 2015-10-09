package com.vox.model
{
	import org.robotlegs.mvcs.Actor;
	
	public class AppModel extends Actor
	{
		protected var _ballClickedCount:int ;
		
		public function AppModel()
		{
			super();
			initialize();
		}
		
		public function get ballClickedCount():int
		{
			return _ballClickedCount ;
		}
		
		public function recordBallClick():void
		{
			_ballClickedCount ++ ;
		}
		
		private function initialize():void
		{
			trace("Model初始化");
			_ballClickedCount = 0 ;
		}
	}
}