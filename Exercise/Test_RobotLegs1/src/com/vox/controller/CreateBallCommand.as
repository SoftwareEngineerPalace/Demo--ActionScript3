package com.vox.controller
{
	import com.vox.view.Ball;
	
	import org.robotlegs.base.EventMap;
	import org.robotlegs.mvcs.Command;
	
	
	public class CreateBallCommand extends Command
	{
		public function CreateBallCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var ball:Ball = new Ball();
			ball.x = Math.random() * 500 ;
			ball.y = Math.random() * 375 ;
			contextView.addChild( ball ) ;
		}
	}
}