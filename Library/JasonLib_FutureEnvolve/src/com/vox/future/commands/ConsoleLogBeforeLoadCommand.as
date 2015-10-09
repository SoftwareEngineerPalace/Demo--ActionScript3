package com.vox.future.commands
{
	import com.vox.future.notifications.msg.ConsoleLogMessage;
	import com.vox.future.utils.FlashConsoleCommonValue;
	
	import org.robotlegs.mvcs.Command;
	
	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class ConsoleLogBeforeLoadCommand extends Command
	{
		[Inject]
		public var msg:ConsoleLogMessage;
		
		public function ConsoleLogBeforeLoadCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			if(msg.cacheBeforeLoad)
			{
				msg.timestamp = new Date().time;
				var cacheList:Array = FlashConsoleCommonValue.cachedLogs;
				cacheList.push(msg);
				while(cacheList.length > 100)
				{
					cacheList.shift();
				}
			}
		}
	}
}