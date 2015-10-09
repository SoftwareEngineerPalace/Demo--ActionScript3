package com.jason.logtool.locallog.logManager
{
	import com.jason.logtool.locallog.logging.ILoggingTarget;
	import com.jason.logtool.locallog.logging.Log;
	import com.jason.logtool.locallog.logging.LogEventLevel;
	import com.jason.logtool.locallog.logging.targets.DebugTarget;
	import com.jason.logtool.locallog.logging.targets.LineFormattedTarget;
	import com.jason.logtool.locallog.logging.targets.TraceTarget;
	
	import flash.system.Capabilities;
	

	public class LogManager
	{
		public static var _targets : Array = [];
		
		public static function initLog():void
		{
			var target : LineFormattedTarget;
			target = new TraceTarget();
			target.level = LogEventLevel.DEBUG;
			target.includeDate = true;
			target.includeTime = true;
			target.includeLevel = true;
			_targets.push(target);
			Log.addTarget(target);
			
			if( Capabilities.isDebugger )
			{
				target = new DebugTarget();
				target.level = LogEventLevel.DEBUG;
				target.includeDate = true;
				target.includeTime = true;
				target.includeLevel = true;
				_targets.push(target);
				Log.addTarget(target);
			}			
		}
		
		/**
		 * 获取播放器启动期间的所有日志 
		 */
		public static function getLifeLogs():Array
		{
			for( var i : int = 0; i < _targets.length; i++ )
			{
				if( _targets[i] is TraceTarget )
				{
					return TraceTarget(_targets[i]).getLifeLogs();
				}
			}
			return [];
		}
		
		public static function setTargetFilters($level:int, $filters:Array):void
		{
			for( var i : int = 0; i < _targets.length; i++ )
			{
				var target : ILoggingTarget = _targets[i];
				if(target.level==$level)
				{
					target.filters = $filters.slice();
				}
			}
		}
	}
}