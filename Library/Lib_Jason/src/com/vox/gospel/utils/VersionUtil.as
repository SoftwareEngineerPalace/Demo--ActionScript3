package com.vox.gospel.utils
{
	import flash.events.ErrorEvent;
	import flash.net.URLLoaderDataFormat;

	/**
	 * 功能: 版本号工具，记录各种常用的版本号
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class VersionUtil
	{
		/** 编译版本 */
		public static var COMPILE_VERSION:String;
		/** 该值传递给version属性表示不使用v版本 */
		public static const VERSION_NONE:String = "VERSION" + String.fromCharCode(160) + "NONE";
		
		/**
		 * 该方法会去服务器请求相对路径代表的文件的带版本号的URL地址
		 * @param path 相对路径
		 * @param callback 回调方法，参数是带版本号的URL地址
		 */		
		public static function toVersionUrl(path:String, callback:Function):void
		{
			// 直接套用集成方法
			VersionUtil.toVersionUrls([path], function(dict:Object):void
			{
				callback(dict[path]);
			});
		}
		
		/**
		 * 该方法会去服务器请求相对路径代表的文件的带版本号的URL地址，与toVersionUrl不同的是该方法可以一次转换多个地址
		 * @param paths 相对路径数组
		 * @param callback 回调方法，参数是带版本号的URL地址字典，使用原始传递进来的path可以取出转换后的URL
		 */		
		public static function toVersionUrls(paths:Array, callback:Function):void
		{
			// 首先加上相对路径
			var tempPaths:Array = [];
			for(var i:int = 0, len:int = paths.length; i < len; i++)
			{
				var path:String = paths[i];
				path = PathUtil.wrapRelativeFlashURL(path);
				tempPaths.push(path);
			}
			var url:String = PathUtil.wrapDomain("flash/gameurl.vpage");
			// 添加参数
			url = URLUtil.appendParams(url, {names:JSON.stringify(tempPaths)});
			LoadUtil.urlLoaderLoad(url, function(data:String):void
			{
				if(callback != null)
				{
					var temp:Object = JSON.parse(data);
					var targetDict:Object = {};
					for(var i:int = 0, len:int = tempPaths.length; i < len; i++)
					{
						var path:String = paths[i];
						if(path != null)
						{
							targetDict[path] = temp[tempPaths[i]];
						}
					}
					callback(targetDict);
				}
			}, function(event:ErrorEvent):void
			{
				// 加载失败了，直接用应用程序的版本返回，防止出现问题
				var targetDict:Object = {};
				for(var i:int = 0, len:int = tempPaths.length; i < len; i++)
				{
					var path:String = paths[i];
					if(path != null)
					{
						var url:String = tempPaths[i];
						url = PathUtil.wrapImgDomain(url);
						url = URLUtil.addVersion(url);
						targetDict[paths[i]] = url;
					}
				}
				if(callback != null) callback(targetDict);
			}, null, URLLoaderDataFormat.TEXT, String(new Date().time));
		}
	}
}