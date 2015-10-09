package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	import utils.Utils;
	
	public class getDefinitionTest extends Sprite
	{
		
		public static var swfAppDomain:ApplicationDomain;
		// 加载资源的计数器
		public static var loadedSrcCount:int = 0;
		
		private var swfUrl:URLRequest;
		
		public function getDefinitionTest()
		{
			swfUrl = new URLRequest("../embeds/img/GuessGameImg.swf");
			
			loadSrc(swfUrl);
		}
		
		private function loadSrc(_url:URLRequest):void
		{
			var swfLoader:Loader = new Loader();
			swfLoader.load(_url);
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoaded);
		}
		
		
		/**swf资源加载完成后。。。*/
		private function onSwfLoaded(event:Event):void
		{
			var swfInfo:LoaderInfo = LoaderInfo(event.target);
			swfAppDomain = swfInfo.applicationDomain;
			loadedSrcCount++;
			
			addElements();
		}
		
		private function addElements():void
		{
			var _scrollbar:MovieClip = Utils.getMC("Scrollbar");
			addChild(_scrollbar);
			_scrollbar.x = 100;
			_scrollbar.y = 100;
			
			var _btn:SimpleButton = Utils.getSimpleButton("registerBtn");
			addChild(_btn);
			_btn.x = 200;
			_btn.y = 100;
			
			var _bitmap:Bitmap = new Bitmap(Utils.getLibPic("vs_txt"));
			addChild(_bitmap);
			_bitmap.x = 200;
			_bitmap.y = 200;
		}
		
	}
}