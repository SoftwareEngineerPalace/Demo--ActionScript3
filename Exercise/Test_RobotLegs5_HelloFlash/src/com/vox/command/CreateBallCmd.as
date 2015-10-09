package com.vox.command
{
	import com.vox.view.Ball;
	
	import org.robotlegs.mvcs.Command;
	
	public class CreateBallCmd extends Command
	{
		public function CreateBallCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			var ball:Ball = new Ball();
			contextView.addChild( ball ) ;
			trace( "create one ball");
			super.execute();
		}
	}
}