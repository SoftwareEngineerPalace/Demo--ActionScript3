package org.robotlegs.demos.helloflash.view
{
	import flash.display.Sprite;
	
	public class Ball extends Sprite
	{
		protected var color:uint;
		protected var radius:Number = 10;
		
		public function Ball()
		{
			alpha = 0.75;
			useHandCursor = true;
			buttonMode = true;
			draw();
		}
		
		public function poke():void
		{
			radius++;
			color = Math.random() * uint.MAX_VALUE;
			draw();
		}
		
		public function draw():void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, radius);
		}
	}
}