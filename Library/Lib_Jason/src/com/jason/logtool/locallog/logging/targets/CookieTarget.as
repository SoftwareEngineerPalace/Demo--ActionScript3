package com.jason.logtool.locallog.logging.targets
{
	import com.jason.logtool.locallog.cookie.FixedLineCookie;
	
	import flash.utils.*;

	/**
	 * 在cookie里记录日志
	 */ 
	public class CookieTarget extends LineFormattedTarget
	{
		private var _lineCookies 	: FixedLineCookie;
		private var _flag			: String;
		/**
		 * @params $cookieName cookie的文件名称
		 * @params $fieldName 字段名称
		 * @params $size 大小限制,byte
		 * @params $len 最大行数
		 */ 
		public function CookieTarget($cookieName:String,$fieldName:String,$size:int,$len:int, $flag:String="")
		{
			super();
			
			this.includeDate = true;
			this.includeTime = true;
			
			_flag = $flag;
			_lineCookies = new FixedLineCookie($cookieName,$fieldName,$size,$len);
		
		}
		
		public function getLifeLogs():Array
		{
			return _lineCookies.lines;
		}
	
		override protected function internalLog(level:int,message:String):void
		{
			_lineCookies.push(message);
		}
	}
}

