package com.vox.future.utils
{
	/**
	 * 功能: URL工具
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class URLUtil
	{
		/**
		 * 连接参数到提供的URL上面，自动判断使用?还是&
		 * @param url 原始URL
		 * @param params 要添加的参数哈希表
		 * @return 连接好的参数
		 */		
		public static function joinParams(url:String, params:Object):String
		{
			var separator:String = (url.indexOf("?") == -1 ? "?" : "&");
			for(var key:String in params)
			{
				var value:Object = params[key];
				url += (separator + key + "=" + value.toString());
				separator = "&";
			}
			return url;
		}
	}
}