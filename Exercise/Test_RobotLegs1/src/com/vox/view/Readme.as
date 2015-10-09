package com.vox.view
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Readme extends Sprite
	{
		protected var _textField:TextField ;
		
		public function Readme()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			_textField = new TextField();
			addChild( _textField ) ;
		}
		
		public function setText( $value:String ):void
		{
			_textField.text = $value ;
		}
	}
}