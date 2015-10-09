package com.vox.gospel.utils
{
	import flash.net.URLVariables;
	
	public class URLUtil
	{
		/** 解析url参数 */
		public static function parseParams($url:String):Object
		{
			var obj:Object = {};
			$url = $url.substr($url.indexOf("?")+1);
			
			try {
				var uvs:URLVariables = new URLVariables($url);
			}
			catch (err:Error)
			{
				uvs = null;
			}
			
			if (uvs)
			{
				for (var attr:String in uvs)
				{
					obj[attr] = uvs[attr];
				}
			}
			else
			{
				// 手动
				var arr1:Array = $url.split("&");
				for each(var prop:String in arr1)
				{
					var arr2:Array = prop.split("=");
					obj[arr2[0]] = decodeURIComponent(arr2[1]);
				}
			}
			return obj;
		}
		
		/**
		 * 去除多余的"/"
		 */
		public static function trim($url:String):String
		{
			return $url.replace(/(?<!:)\/{2,}/g, "/");
		}
		
		/**
		 * 添加参数
		 * @param url 原始URL
		 * @param params 要添加的参数哈希表
		 * @param replace 是否替换原有的（默认true）
		 * @return url
		 */
		public static function appendParams(url:String, params:Object, replace:Boolean = true):String
		{
			var params0:Object = {};
			var index:int = url.indexOf("?");
			if (index >= 0)
			{
				var sQuery:String = url.substr(url.indexOf("?")+1);
				url = url.substr(0, index);
				var aQuery:Array = sQuery.split("&");
				for each(var sParam:String in aQuery)
				{
					var aParam:Array = sParam.split("=");
					params0[aParam[0]] = decodeURIComponent(aParam[1]);
				}
			}
			for (var key:String in params)
			{
				if (!replace && key in params0) continue;
				params0[key] = params[key];
			}
			
			aQuery = [];
			for (key in params0) aQuery.push(key + "=" + encodeURIComponent(params0[key]));
			if (aQuery.length) url = url + "?" + aQuery.join("&");
			
			return url;
		}
		
		private static var _versionJudge:RegExp = /\d+/;
		private static var _versionSplit:RegExp = /(.+)(\.[^\.\?]+(\?.*)?)/;
		/**
		 * 向提供的URL中添加一个-V20形式的版本号
		 * @param url 要添加版本号的URL
		 * @param version 要添加的版本号，必须是全部为数字组成的字符串，不传递表示使用程序编译版本号
		 * @return 添加了版本号后的URL路径
		 */		
		public static function addVersion(url:String, version:String=null):String
		{
			if(version == null) version = VersionUtil.COMPILE_VERSION;
			// 首先判断version的合法性，不过是在CONFIG::RELEASE情况下生效
			CONFIG::RELEASE
			{
				if(!_versionJudge.test(version))
				{
					throw new Error("version字符串必须全部由数字组成。");
				}
			}
			// 如果version不是以20开头的，则在前面加上20，因为规则如此
			if(version.substr(0, 2) != "20")
			{
				version = "20" + version;
			}
			// 开始插入版本号
			var result:Object = _versionSplit.exec(url);
			if(result == null) return url;
			return result[1] + "-V" + version + result[2];
		}
		
		/**
		 * 检查一个图片url是否是正确的
		 * url:返回的图片地址
		 * */
		private static var urlRegExp:RegExp= /^[a-zA-Z]+:\/\/(?:\w+(?:-\w+)*)(?:\.\S+)*(?:\?\S*)?$/
		public static function checkUrl(url:String):Boolean
		{
			if(urlRegExp.test(url)){
				return true;
			}
			return false;
		}
		
		
		/**
		 * 替换host
		 */
		public static function replaceHost(url:String, host:String):String
		{
			var regex:RegExp = /^(?:[^\/]+):\/{2,}(?:[^\/]+)\//;
			var arr:Array = url.match(regex);
			if (arr && arr.length > 0)
			{
				url = url.substr(arr[0].length);
			}
			url = host + url;
			return url;
		}
		
	}
}


