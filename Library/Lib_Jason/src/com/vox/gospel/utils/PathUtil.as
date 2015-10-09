package com.vox.gospel.utils
{
	/**
	 * 功能: 该类用于转换相对路径为正确的路径，防止出错
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class PathUtil
	{
		private static var _parameters:Object
		
		/**
		 * 防止导入过多类定义，如需使用该类需初始化之，这样可以让该类使用更独立
		 * @param parameters 参数集合
		 */		
		public static function initialize(parameters:Object):void
		{
			_parameters = parameters;
		}
		
		/**
		 * 将相对路径包装为正式环境的flash路径
		 * @param path 相对路径
		 * @return 正式环境下的flash路径
		 */		
		public static function wrapFlashURL(path:String):String
		{
			return wrapImgDomain(wrapRelativeFlashURL(path));
		}
		
		/**
		 * 将相对路径包装为相对flash路径
		 * @param path 相对路径
		 * @return 相对flash路径
		 */		
		public static function wrapRelativeFlashURL(path:String):String
		{
			return "resources/apps/flash/" + path;
		}
		
		/**
		 * 将相对路径包装为正式环境
		 * @param path 相对路径
		 * @return 正式环境下的路径
		 */		
		public static function wrapDomain(path:String):String
		{
			var result:String = "";
			try
			{
				var domain:String = _parameters.domain;
				result = domain + "/" + path;
			}
			catch(error:Error) 
			{
				trace("there are errors in PathUtils");
			}
			return result;
		}
		
		/**
		 * 将相对路径包装为正式环境
		 * @param path 相对路径
		 * @return 正式环境下的路径
		 */		
		public static function wrapImgDomain(path:String):String
		{
			var result:String = "";
			try
			{
				var imgDomain:String = _parameters.imgDomain;
				if(imgDomain == null) imgDomain = _parameters.imgdomain;
				result =  imgDomain + "/" + path;
			}
			catch(error:Error) 
			{
				trace("there are errors in PathUtils");
			}
			return result;
		}
	}
}