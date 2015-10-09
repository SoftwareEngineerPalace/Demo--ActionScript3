package com.jason.logtool.locallog.cookie
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class FixedBaseCookie
	{
		/**
		 * 单个cookie的大小,单位:byte
		 */ 
		protected var _maxSize 		: int;
		protected var _so			: SharedObject;
		protected var _data 		: Object;
		protected var _forbidden	: Boolean = false;
		protected var _fieldName	: String;
		protected var _fileName		: String;
		
		public function FixedBaseCookie($filename:String, $field:String, $size:int)
		{
			_maxSize = $size<<10;
			_fieldName = $field;
			_fileName = $filename;
			try
			{
				_so = SharedObject.getLocal($filename,"/");
				_so.addEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
				_data = _so.data[$field];
			}
			catch(e:Error)
			{
				_forbidden = true;
			}
		}
		
		public function destroy():void
		{
			if(_so)
			{
				_so.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
				_so.close();
				_so = null;
			}
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			if( event.info.code == "SharedObject.Flush.Failed" )
			{
				clear();
			}
			else if( event.info.code == "SharedObject.Flush.Success" )
			{
				
			}
		}
		
		public function clear():void
		{
			
		}
		
		public function get data():Object
		{
			return _data;
		}
		public function set data($value:Object):void
		{
			_data = $value;
		}
		
		public function flush():void
		{
			try
			{
				_so.flush();
			}
			catch(e:Error)
			{
				_forbidden = true;
			}
		}
		
	}
}
