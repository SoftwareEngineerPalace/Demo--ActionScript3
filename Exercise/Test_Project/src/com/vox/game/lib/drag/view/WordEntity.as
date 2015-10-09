package com.vox.game.lib.drag.view
{
	import flash.geom.Rectangle;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.ui.GBuilderBase;
	import ghostcat.ui.controls.GText;
	
	public class WordEntity extends GBuilderBase
	{
		public var fixedWidth    :Number = NaN ;
		public var fixedHeight   :Number = NaN ;
		public var fixedRecBounds:Rectangle ;
		
		public var txt_content   :GText ;
		public var btn           :GMovieClip ;
		
		private var _word        :String ;
		
		public function WordEntity(skin:*=null, $word:String )
		{
			super(skin;
		}
		
		public function get word():String
		{
			return _word ;
		}
		
		override public function get width():Number
		{
			// TODO Auto Generated method stub
			return super.width;
		}
		
		
	}
}