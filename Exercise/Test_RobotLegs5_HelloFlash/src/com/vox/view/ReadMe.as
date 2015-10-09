package com.vox.view
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ReadMe extends Sprite
	{
		private var _tf:TextField ;
		
		public function ReadMe()
		{
			super();
			initialzie();
		}
		
		private function initialzie():void
		{
			x = y = 100 ;
			_tf = new TextField() ;
			addChild( _tf ) ;
			updateText( 0 ) ;
		}
		
		public function updateText( $num:uint ):void
		{
			_tf.text = "点击数为: " + $num ;
		}
	}
}