package org.robotlegs.demos.helloflash.model
{
	import org.robotlegs.mvcs.Actor;
	
	public class StatsModel extends Actor
	{
		protected var _ballClickCount:int;
		
		public function StatsModel()
		{
			_ballClickCount = 0;
		}
		
		public function recordBallClick():void
		{
			_ballClickCount++;
		}
		
		public function get ballClickCount():int
		{
			return _ballClickCount;
		}
	}
}