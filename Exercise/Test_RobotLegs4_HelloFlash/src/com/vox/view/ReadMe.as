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
			initialize();
		}
		
		public function updateTxt( $txt:String ):void
		{
			_tf.text = $txt ;
		}
		
		private function initialize():void
		{
			_tf = new TextField();
			addChild( _tf ) ;
		}
	}
}