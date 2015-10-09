package com.vox.gospel.utils
{
	import flash.events.ErrorEvent;
	import flash.net.URLLoaderDataFormat;

	/**
	 * 功能: 配置工具类，用于加载并且解析配置文件的
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class ConfigUtil
	{
		/**
		 * 加载并解析配置文件
		 * @param url 要加载的配置文件的URL
		 * @param callback 加载完毕的回调，参数是一个Object，包含了键值对配置数据，加载失败返回空Object
		 */		
		public static function loadKeyValueConfig(url:String, callback:Function):void
		{
			// 开始加载
			LoadUtil.urlLoaderLoad(url,
				function(data:String):void
				{
					// 开始解析
					var arr:Array = data.split(/[\r\n]+/);
					var result:Object = {};
					for(var i:int = 0, len:int = arr.length; i < len; i++)
					{
						var line:String = StringUtils.trim(arr[i]);
						var index:int = line.indexOf("=");
						result[line.substring(0, index)] = line.substring(index + 1);
					}
					if(callback != null) callback(result);
				},
				function(error:ErrorEvent):void
				{
					if(callback != null) callback({});
				},
				null, URLLoaderDataFormat.TEXT, VersionUtil.VERSION_NONE);
		}
	}
}