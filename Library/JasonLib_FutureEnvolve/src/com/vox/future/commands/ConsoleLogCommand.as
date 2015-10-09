package com.vox.future.commands
{
	import com.junkbyte.console.Cc;
	import com.vox.future.notifications.msg.ConsoleLogMessage;
	
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class ConsoleLogCommand extends Command
	{
		[Inject]
		public var msg:ConsoleLogMessage;
		
		public function ConsoleLogCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if(msg.showTime)
			{
				var date:Date = (msg.timestamp > 0 ? new Date(msg.timestamp) : new Date());
				var timeStr:String = "[" + date.hours + ":" + date.minutes + ":" + date.seconds + "]";
				if(msg.channel == null) Cc.log.apply(null, [timeStr].concat(msg.data));
				else Cc.logch.apply(null, [msg.channel, timeStr].concat(msg.data));
			}
			else
			{
				if(msg.channel == null) Cc.log.apply(null, msg.data);
				else Cc.logch.apply(null, [msg.channel].concat(msg.data));
			}
			// 为了持久化而保存，10分钟后销毁
			setTimeout(onTimeoutOK, 600000, msg.data);
		}
		
		private static function onTimeoutOK(key:*):void
		{
		}
	}
}