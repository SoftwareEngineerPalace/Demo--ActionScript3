package com.vox.gospel.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;

	/**
	 * 功能: 用来加载位图数据的工具，支持加载通过_compress.jsfl脚本压缩过的swf文件中的位图数据
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class BitmapLoadUtil
	{
		public function BitmapLoadUtil()
		{
		}
		
		/**
		 * 加载位图数据
		 * @param url 位图数据路径，可以是文件本身，也可以是通过_compress.jsfl脚本压缩过的swf文件路径
		 * @param version 加载时添加在URL中的版本字符串，null表示不使用
		 * @param bmp 可以传递一个已有的Bitmap作为加载代理器，否则新建一个
		 * @return 一个Bitmap对象，可以用来当做LoaderProxy
		 */		
		public static function loadBitmap(url:String, version:String=null, bmp:Bitmap=null):Bitmap
		{
			if(bmp == null) bmp = new Bitmap();
			//先trim掉版本号
			var index:int = url.indexOf("?");
			var result:String = url.substr(0,index);
			var defaultVersion:String 
			if(index ==-1){
				defaultVersion = null
			}
			else{
				defaultVersion = url.substr(index+1);
			}
			if(version == null && defaultVersion!= null)
				version = defaultVersion
			// 首先尝试加载图片文件对应的swf文件
			LoadUtil.loaderLoad(result + ".swf", function(loader:Loader):void
			{
				// 加载成功了，从应用程序域中取出链接名指向的类
				var linkName:String = loader.contentLoaderInfo.applicationDomain.getQualifiedDefinitionNames()[0];
				var cls:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(linkName) as Class;
				// 实例化成BitmapData并赋值给bmp对象
				bmp.bitmapData = new cls(0, 0);
				// 派发事件
				bmp.dispatchEvent(new Event(Event.COMPLETE, true, true));
			}, function(event:ErrorEvent):void
			{
				// 加载失败了，说明没有进行过压缩，直接加载url
				LoadUtil.loaderLoad(url, function(loader:Loader):void
				{
					// 加载成功了，直接把加载到的BitmapData赋值给bmp对象
					bmp.bitmapData = Bitmap(loader.content).bitmapData;
					// 派发事件
					bmp.dispatchEvent(new Event(Event.COMPLETE, true, true));
				}, function(event:ErrorEvent):void
				{
					// 加载依然失败了，直接派发错误事件
					bmp.dispatchEvent(event);
				}, null, null, version);
			}, null, null, version);
			// 返回作为代理的bmp对象
			return bmp;
		}
	}
}