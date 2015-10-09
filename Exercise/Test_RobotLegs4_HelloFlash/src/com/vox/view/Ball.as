package com.vox.view
{
	import flash.display.Sprite;
	
	public class Ball extends Sprite
	{
		protected var _color:uint ;
		protected var _radius:uint ;
		
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
			_radius = 10 ;
			_color = 0xff0000 ;
			buttonMode = true ;
			useHandCursor = true ;
			mouseEnabled = true ;
			this.x = Math.floor( Math.random() * 600 ) ;
			this.y = Math.floor( Math.random() * 450 ) ; 
			draw() ;
		}
		
		private function draw():void
		{
			this.graphics.clear() ;
			this.graphics.beginFill( _color, 1 ) ;
			this.graphics.drawCircle( 0, 0, _radius ) ;
			this.graphics.endFill() ;
		}
	}
}