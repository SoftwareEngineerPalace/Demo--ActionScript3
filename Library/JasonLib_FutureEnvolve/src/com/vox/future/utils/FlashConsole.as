package com.vox.future.utils
{
	import com.junkbyte.console.Cc;
	import com.vox.future.commands.ConsoleLogBeforeLoadCommand;
	import com.vox.future.commands.ConsoleLogCommand;
	import com.vox.future.managers.ContextManager;
	import com.vox.future.notifications.messages.ConsoleLogMessage;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class FlashConsole
	{
		private static var _stage:Stage;
		
		public function FlashConsole()
		{
		}
		
		/**
		 * 初始化Flash Console
		 * @param display 已经或即将被添加到显示列表中的对象
		 */
		public static function initConsole(display:DisplayObject):void
		{
			Cc.startOnStage(display, "\\");
			Cc.width = 600;
			Cc.height = 200;
			Cc.fpsMonitor = true;
			Cc.memoryMonitor = true;
			Cc.commandLine = true;
			Cc.config.commandLineAllowed = true;
			
			Cc.addSlashCommand("tfv", onTestFlashVars, "键入该命令可以获取当前小游戏的FlashVars字符串形式");
			
			if(display.stage != null)
			{
				_stage = display.stage;
			}
			else
			{
				display.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void
				{
					display.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
					_stage = display.stage;
				});
			}
			if(ContextManager.context != null)
			{
				setTimeout(function():void
				{
					// 移除原有Command映射
					ContextManager.context.unmapCommand(ConsoleLogMessage.CONSOLE_LOG_MESSAGE, ConsoleLogBeforeLoadCommand);
					// 连接ConsoleLogMessage和ConsoleLogCommand
					ContextManager.context.mapCommand(ConsoleLogMessage.CONSOLE_LOG_MESSAGE, ConsoleLogCommand);
					// 如果有缓存的消息，全部再次发送
					var cmd:ConsoleLogCommand = new ConsoleLogCommand();
					for(var i:int = 0, len:int = FlashConsoleCommonValue.cachedLogs.length; i < len; i++)
					{
						var msg:ConsoleLogMessage = FlashConsoleCommonValue.cachedLogs.shift();
						cmd.msg = msg;
						cmd.execute();
					}
				}, 0);
			}
		}
		
		private static function onTestFlashVars():void
		{
			if(_stage == null)
			{
				Cc.error("没有获取到Stage引用");
				return;
			}
			var flashVars:Object = _stage.loaderInfo.parameters;
			if(flashVars == null)
			{
				Cc.error("不存在flashVars");
				return;
			}
			var arr:Array = [];
			// 解析格式（不用JSON的原因是格式不好看）
			var reg:RegExp = /^\d*\.?\d+|true|false$/;
			for(var key:String in flashVars)
			{
				var value:* = flashVars[key];
				if(value is String)
				{
					if(value.length > 9 || !reg.test(value))
					{
						value = "'" + value + "'";
					}
				}
				arr.push(key + ":" + value);
			}
			var str:String = "{\n\t\t\t\t" + arr.join(",\n\t\t\t\t") + "\n\t\t\t}";
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, str);
			Cc.warn("已将目标字符串复制入剪贴板，请在指定项目【testFlashVars】属性中【粘贴】即可");
		}
	}
}