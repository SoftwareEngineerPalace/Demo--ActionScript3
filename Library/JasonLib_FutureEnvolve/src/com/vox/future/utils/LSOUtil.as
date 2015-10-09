package com.vox.future.utils
{
	import ghostcat.util.data.LocalStorage;

	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class LSOUtil
	{
		/**
		 * 获取本地存储数据
		 * @param name 名字
		 * @param url 路径
		 * @return 本地存储数据
		 */		
		public static function getLocalValue(name:String, url:String="/"):*
		{
			var ls:LocalStorage = new LocalStorage(name, url);
			return ls.getValue();
		}
		
		/**
		 * 设置本地存储数据
		 * @param data 本地存储数据
		 * @param name 名字
		 * @param url 路径
		 */		
		public static function setLocalValue(data:*, name:String, url:String="/"):void
		{
			var ls:LocalStorage = new LocalStorage(name, url);
			ls.setValue(data);
		}
	}
}