package com.jason.logtool.locallog.cookie
{
	import flash.net.SharedObject;

	public class DynamicLineCookie extends DynamicBaseCookie
	{
		private var _maxLine : int = 0;
		private var _reverse : Boolean = false;
		
		public function DynamicLineCookie($filename:String, $field:String, $size:int, $maxLine:int, $reverse:Boolean=false)
		{
			super($filename,$field,$size);
			
			_reverse = $reverse;
			_maxLine = $maxLine;
		}
		
		override public function clear():void
		{
			try
			{
				var so : SharedObject = SharedObject.getLocal(_fileName,"/");
				if( so ) so.data[_fieldName] = [];
			}
			catch(e:Error)
			{
			}
		}
		
		public function get lines():Array
		{
			var ls : Array = data as Array;
			if( ls==null ) ls = [];
			return ls;
		}
		
		override public function set data($value:Object):void
		{
			if( $value == null || !($value is Array)) $value = [];
			
			var so : SharedObject = SharedObject.getLocal(_fileName,"/");
			so.data[_fieldName] = $value;
			
			while($value.length > 0 && ($value.length>_maxLine || so.size >_maxSize)) 
			{
				if(_reverse)$value.pop();
				else $value.shift();
			}
			
			so.flush();
		}
		
		public function push(line:Object):void
		{
			try
			{
				var so : SharedObject = SharedObject.getLocal(_fileName,"/");
				var lines : Array = so.data[_fieldName];
				if( lines == null )
				{
					lines = [];
					so.data[_fieldName] = lines;
				}
				lines.push(line);
				while( lines.length>_maxLine || (so.size >_maxSize && lines.length) ) 
				{
					if(_reverse)lines.pop();
					else lines.shift();
				}
				so.flush();
			}
			catch(e:Error)
			{}
		}
	}
}