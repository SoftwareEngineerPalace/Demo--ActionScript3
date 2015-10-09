package com.vox.future.notifications.msg
{
	import flash.events.Event;
	
	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class ConsoleLogMessage extends Event
	{
		public static const CONSOLE_LOG_MESSAGE:String = "consoleLogMessage";
		
		/** 日志频道 */
		public var channel:String = null;
		
		/** 是否显示时间 */
		public var showTime:Boolean = false;
		
		/** 如果显示时间，则表示要显示的时间，如果为0表示使用当前时间戳 */
		public var timestamp:Number = 0;
		
		/** 在加载FlashConsole前是否缓存，最多缓存100条，超过100条将按队列舍弃 */
		public var cacheBeforeLoad:Boolean = false;
		
		/** 日志内容数组 */
		public var data:Array;
		
		public function ConsoleLogMessage(...data)
		{
			this.data = data;
			super(CONSOLE_LOG_MESSAGE);
		}
	}
}