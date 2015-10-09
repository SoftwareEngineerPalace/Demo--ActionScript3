package  com.jason.logtool.locallog.cookie
{
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class DynamicBaseCookie
	{
		/**
		 * 单个cookie的大小,单位:byte
		 */ 
		protected var _maxSize 		: int;
		protected var _forbidden	: Boolean = false;
		protected var _fieldName	: String;
		protected var _fileName		: String;
		
		public function DynamicBaseCookie($filename:String, $field:String, $size:int)
		{
			_maxSize = $size<<10;
			_fieldName = $field;
			_fileName = $filename;
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
			event.target.removeEventListener(NetStatusEvent.NET_STATUS,onNetStatus);
		}
		
		public function clear():void
		{
			
		}
		
		public function get data():Object
		{
			try
			{
				var so : SharedObject;
				so = SharedObject.getLocal(_fileName,"/");
				if( so ) return so.data[_fieldName];
			}
			catch(e:Error)
			{
				
			}
			return null;
		}
		public function set data($value:Object):void
		{
			try
			{
				var so : SharedObject;
				so = SharedObject.getLocal(_fileName,"/");
				if( so )
				{
					so.data[_fieldName] = $value;
					so.flush();
				}
			}
			catch(e:Error)
			{
				;
			}
		}
		
	}
}
