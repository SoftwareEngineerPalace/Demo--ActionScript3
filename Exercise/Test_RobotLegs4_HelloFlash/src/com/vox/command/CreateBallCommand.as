package com.vox.command
{
	import com.vox.view.Ball;
	
	import org.robotlegs.mvcs.Command;
	
	public class CreateBallCommand extends Command
	{
		public function CreateBallCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			
			var ball:Ball = new Ball();
			contextView.addChild( ball ) ;
		}
	}
}