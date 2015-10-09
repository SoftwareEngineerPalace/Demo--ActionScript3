package com.jason.logtool.pingback.def
{
	public class PingbackVO
	{
		private var _type            :String ;
		private var _app             :String
		private var _module          :String ;
		private var _op              :String; 
		private var _code            :String ;
		private var _target          :String ;
		private var _iParam          :Number ;
		private var _sParam          :String ;
		private var _numParam        :uint ;
		private var _studyType       :String ;

		public function get studyType():String
		{
			return _studyType;
		}

		public function set studyType(value:String):void
		{
			_studyType = value;
		}

		public function get numParam():uint
		{
			return _numParam;
		}

		public function set numParam(value:uint):void
		{
			_numParam = value;
		}

		/**字符串数值，根据实际需求约定，没有则留空*/
		public function get sParam():String
		{
			return _sParam;
		}

		public function set sParam(value:String):void
		{
			_sParam = value;
		}

		/**整数数值，根据实际需求约定，例如对于时间统计的log用i0记录执行时间*/
		public function get iParam():Number
		{
			return _iParam;
		}

		public function set iParam(value:Number):void
		{
			_iParam = value;
		}

		/**当前操作相关的url或者id*/
		public function get target():String
		{
			return _target;
		}

		public function set target(value:String):void
		{
			_target = value;
		}

		/**约定码，例如 network_error, timeout, …… 可留空*/
		public function get code():String
		{
			return _code;
		}

		public function set code(value:String):void
		{
			_code = value;
		}

		/**当前操作的名称. 比如: loadSWF是加载swf*/
		public function get op():String
		{
			return _op;
		}

		public function set op(value:String):void
		{
			_op = value;
		}

		/**执行本操作的类名*/
		public function get module():String
		{
			return _module;
		}

		public function set module(value:String):void
		{
			_module = value;
		}

		/**项目工程名*/
		public function get app():String
		{
			return _app;
		}

		public function set app(value:String):void
		{
			_app = value;
		}

		/**日志类型，例如 exectime 用于执行时间，其他再定*/
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}