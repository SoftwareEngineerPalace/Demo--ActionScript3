package org.robotlegs.demos.helloflash.controller
{
	import org.robotlegs.demos.helloflash.view.Ball;
	import org.robotlegs.mvcs.Command;
	
	public class CreateBallCommand extends Command
	{
		override public function execute():void
		{
			var ball:Ball = new Ball();
			ball.x = Math.random() * 500;
			ball.y = Math.random() * 375;
			contextView.addChild(ball);
		}
	}
}