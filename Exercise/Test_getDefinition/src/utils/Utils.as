package utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.system.ApplicationDomain;
	import flash.text.TextFormat;

	public class Utils
	{
		public static var titleFormat:TextFormat;
		public static var textFormat1:TextFormat;
		public static var textFormat2:TextFormat;
		public static var textFormat3:TextFormat;
		
		public function Utils()
		{
			
		}
		
		
		public static function getSimpleButton(_btnName:String, _appDomain:ApplicationDomain = null):SimpleButton
		{
			var _btn:SimpleButton = getSource(_btnName,_appDomain) as SimpleButton;
			return _btn;
		}
		
		public static function getMC(_mcName:String, _appDomain:ApplicationDomain = null):MovieClip
		{
			var _mc:MovieClip = getSource(_mcName,_appDomain) as MovieClip;
			return _mc;
		}
		
		private static function getSource(_srcName:String, _appDomain:ApplicationDomain = null):Object
		{
			if(_appDomain == null)
			{
				_appDomain = getDefinitionTest.swfAppDomain;
			}
			var _class:Class = _appDomain.getDefinition(_srcName) as Class;
			return (new _class);
		}
		
		/**
		 * 加载swf库中的图片资源
		 * */
		public static function getLibPic(_mcName:String, _appDomain:ApplicationDomain = null):BitmapData
		{
			var _pic:BitmapData = getSource(_mcName,_appDomain) as BitmapData;
			return _pic;
		}
	}
}