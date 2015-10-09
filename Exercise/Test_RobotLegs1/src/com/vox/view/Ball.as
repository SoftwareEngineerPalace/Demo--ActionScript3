package com.vox.view
{
	import flash.display.Sprite;
	
	public class Ball extends Sprite
	{
		protected var color:uint; 
		protected var radius:Number = 10; 
		
		public function Ball()
		{
			super();
			initilize();
		}
		
		public function poke():void
		{
			radius ++ ;
			color = Math.random() * uint.MAX_VALUE ;
			draw() ;
		}
		
		private function initilize():void
		{
			alpha = 0.75 ;
			x = Math.random() * 700 ;
			y = Math.random() * 470 ;
			//useHandCursor = true; 
			buttonMode = true ;
			draw() ;
		}
		
		private function draw():void
		{
			graphics.clear() ;
			graphics.beginFill( color ) ;
			graphics.drawCircle( 0, 0, radius ) ;
			graphics.endFill() ;
		}
	}
}