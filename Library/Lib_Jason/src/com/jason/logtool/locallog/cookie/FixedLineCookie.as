package com.jason.logtool.locallog.cookie
{
	import flash.net.SharedObject;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class FixedLineCookie extends FixedBaseCookie
	{
		private var _maxLine : int = 0;
		private var _timeout : uint = 0;
		private var _updateDuration : int;
		private var _reverse : Boolean = false;
		
		/**
		 * 如果$updateDuration,表示不自动更新
		 * $size 表示该cookie文件大小,单位:kb
		 * $updateDuration,定期更新时间,如果<0,则不自动定时更新
		 * $nocache	是否不需要在内存里缓存数据
		 * $reverse 是否为倒序排列
		 */ 
		public function FixedLineCookie($filename:String, $field:String, $size:int, $maxLine:int, $updateDuration:int=1000,$reverse:Boolean=false)
		{
			super($filename,$field,$size);
			
			_reverse = $reverse;
			_maxLine = $maxLine;
			_updateDuration = $updateDuration;
			
			if( _data == null || !(_data is Array) )
			{
				_data = [];
				if(!_forbidden)
				{
					_so.data[$field] = _data;
					flush();
				}
			}
		}
		
		override public function clear():void
		{
			_data = [];
			if(_forbidden) return;
			super.flush();
		}
		
		public function get lines():Array
		{
			var ls : Array = data as Array;
			if( ls==null ) ls = [];
			return ls;
		}
		
		override public function set data($value:Object):void
		{
			_data = $value;
			if( _data == null || !(_data is Array)) _data = [];
			flush();
		}
		
		public function push(line:Object):void
		{
			lines.push(line);
			if(_forbidden) return;
			if(_timeout==0 && _updateDuration>0) _timeout = setTimeout(flush,_updateDuration);	
		}
		
		override public function destroy():void
		{
			if( _timeout ) clearTimeout(_timeout);
			_timeout = 0;
			
			super.destroy();
		}
		
		override public function flush():void
		{
			if(_forbidden) return;
			
			if(_timeout) clearTimeout(_timeout);
			_timeout = 0;
			
			if(lines==null) return;
			
			while( lines.length>_maxLine || (_so.size >_maxSize && lines.length) ) 
			{
				if(_reverse)lines.pop();
				else lines.shift();
			}
			super.flush();
		}
	}
}