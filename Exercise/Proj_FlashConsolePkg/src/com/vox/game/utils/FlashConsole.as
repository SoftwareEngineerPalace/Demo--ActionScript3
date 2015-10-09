package com.vox.game.utils
{
	import com.junkbyte.console.Cc;
	import com.vox.future.commands.ConsoleLogBeforeLoadCommand;
	import com.vox.future.commands.ConsoleLogCommand;
	import com.vox.future.managers.ContextManager;
	import com.vox.future.notifications.messages.ConsoleLogMessage;
	import com.vox.future.utils.FlashConsoleCommonValue;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.setTimeout;

	public class FlashConsole
	{
		private static var _stage:Stage ;
		private static var _toRemoveCommandMapFlag:uint ;
	
		public static function initConsole( $display:DisplayObject ):void
		{
			Cc.startOnStage( $display, "\\") ;
			Cc.width = 500 ;
			Cc.height = 150 ;
			Cc.fpsMonitor = true ;
			Cc.memoryMonitor = true ;
			Cc.commandLine = true ;
			Cc.config.commandLineAllowed = true ;
			Cc.addSlashCommand("flashvar", onGetFlashVars, "获取flashvar" ) ;
			
			//获取stage
			if( $display.stage )
			{
				_stage = $display.stage ;
			}
			else
			{
				$display.addEventListener( Event.ADDED_TO_STAGE, function( $evt:Event ):void
				{
					$evt.currentTarget.removeEventListener( $evt.target, arguments.callee ) ;
					_stage = $display.stage ;
				});
			}
			
			if( ContextManager.context != null )
			{
				_toRemoveCommandMapFlag = setTimeout( removeCommandMap, 1000 ) ;
			}
		}
		
		private static function removeCommandMap():void
		{
			//移除原有的Command映射
			ContextManager.context.unmapCommand( ConsoleLogMessage.CONSOLE_LOG_MESSAGE, ConsoleLogBeforeLoadCommand ) ;
			//连接ConsoleLogMessage和ConsoleLogCommand
			ContextManager.context.mapCommand( ConsoleLogMessage.CONSOLE_LOG_MESSAGE, ConsoleLogCommand ) ;
			//如果有缓存的消息，全部再次发送
			var cmd:ConsoleLogCommand = new ConsoleLogCommand();
			for (var i:int = 0, len:uint = FlashConsoleCommonValue.cachedLogs.length; i < len; i++) 
			{
				var msg:ConsoleLogMessage = FlashConsoleCommonValue.cachedLogs.shift();
				cmd.msg = msg ;
				cmd.execute() ;
			}
		}
		
		private static function onGetFlashVars():void
		{
			if( !_stage )
			{
				Cc.error("没有获取到Stage的引用");
				return ;
			}
			
			var flashVars:Object = _stage.loaderInfo.parameters ;
			if( !flashVars )
			{
				Cc.error("不存在 flashvar");
				return ;
			}
			
			var arr:Array = [];
			//解析格式（不用JSON的原因是格式不好看）
			var reg:RegExp = /^\d*\.?\d+|true|false$/;
			for (var key:String in flashVars )
			{
				var value:* = flashVars[ key ] ;
				if( value is String )
				{
					if( value.length > 0 || !reg.test( value ) )
					{
						value = "'" + value + "'" ;
					}
				}
				arr.push( key + ":" + value ) ;
			}
			var str:String = "{\n\t\t\t\t" + arr.join(",\n\t\t\t\t") + "\n\t\t\t\t}" ;
			Clipboard.generalClipboard.setData( ClipboardFormats.TEXT_FORMAT, str ) ;
			Cc.warn("已将目标字符串复制入剪贴板");
		}
	}
}