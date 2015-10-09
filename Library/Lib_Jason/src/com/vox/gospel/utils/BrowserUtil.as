package com.vox.gospel.utils
{
	import flash.external.ExternalInterface;

	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class BrowserUtil
	{
		/**
		 * 获取IE版本号，其他浏览器返回"0"
		 */		
		public static function getIEVersion():String
		{
			var ieVersion:String = ExternalInterface.call('function getIEVersion() {var tridentVersion = (navigator.userAgent.toLowerCase().match(/trident\\/(\\d+)/) || [\'\', 0])[1];var msieVersion = (navigator.userAgent.toLowerCase().match(/msie (\\d+)/) || [\'\', 0])[1]; if(tridentVersion == "7") return 11; else return msieVersion;}');
			return ieVersion;
		}
	}
}