package com.vox.view
{
	import flash.display.Sprite;
	
	public class Ball extends Sprite
	{
		private var _color:uint ;
		private var _radius:uint ;
		
		public function Ball()
		{
			super();
			
			initialize();
		}
		
		public function poke():void
		{
			_radius ++ ;
			_color = Math.random() * uint.MAX_VALUE ;
			draw() ;
		}
		
		private function initialize():void
		{
			_color = 0xFF0000 ;
			_radius = 10 ;
			buttonMode = true ;
			useHandCursor = true ;
			x = Math.floor( Math.random() * 700 ) ;
			y = Math.floor( Math.random() * 470 ) ;
			draw() ;
		}
		
		private function draw():void
		{
			graphics.clear() ;
			graphics.beginFill( _color, 1 ) ;
			graphics.drawCircle( 0, 0, _radius ) ;
			graphics.endFill() ;
		}
	}
}