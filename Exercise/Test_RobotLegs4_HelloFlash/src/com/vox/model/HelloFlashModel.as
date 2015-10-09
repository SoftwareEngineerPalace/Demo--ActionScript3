package com.vox.model
{
	import org.robotlegs.mvcs.Actor;
	
	public class HelloFlashModel extends Actor
	{
		private var _ballClickedNum:uint ;
		
		public function HelloFlashModel()
		{
			super();
		}
		
		public function get ballClickedNum():uint
		{
			return _ballClickedNum ;
		}
		
		public function recordBallClicked():void
		{
			_ballClickedNum ++ ;
		}
		
	}
}