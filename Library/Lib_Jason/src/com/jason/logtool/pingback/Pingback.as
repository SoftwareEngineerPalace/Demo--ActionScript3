package com.jason.logtool.pingback
{
	
	import com.jason.logtool.pingback.def.PingbackVO;
	
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	
	/**
	 * 远程日志
	 * </br>
	 * 使用方法以wiki说明为准:
	 * </br>
	 * <a href="http://wiki.17zuoye.net/pages/viewpage.action?pageId=2294061">http://wiki.17zuoye.net/pages/viewpage.action?pageId=2294061</a>
	 */
	public class Pingback
	{
		public static const LEVEL_EMERG:int = 0;
		public static const LEVEL_ALERT:int = 1;
		public static const LEVEL_CRIT:int = 2;
		public static const LEVEL_ERROR:int = 3;
		public static const LEVEL_WARNING:int = 4;
		public static const LEVEL_NOTICE:int = 5;
		public static const LEVEL_INFO:int = 6;
		public static const LEVEL_DEBUG:int = 7;
		
		// 初始化
		{
			initPingbackVOProps();
		}
		
		private static const _VO_PROPS:Array = []
		// PingbackVO的公开属性处理
		private static function initPingbackVOProps():void
		{
			var desc:XML = describeType(PingbackVO);
			var list:XMLList = desc.factory.variable.@name;
			_VO_PROPS.length = 0;
			for each (var name:String in list)
			{
				_VO_PROPS.push(name);
			}
		}
		
		/** 实例 */
		private static var _instance                  : Pingback ;
		
		/** log处理函数 */
		private var _handler                           : Function;
		
		/** 默认处理函数中的js方法名称 */
		private static const JSPingbackFun            : String = "window.voxLogger.log";
		
		/** 
		 * 公用属性集合，key-value形式
		 * <br/>
		 * 添加到此集合中的数据，会附加到所有日志中
		 * <br/>
		 * 同名属性会被用户数据中的覆盖
		 */
		public var commonData:Object = {};
		
		private var _parameters:Object;
		
		/**
		 * @private
		 */
		public function Pingback( $enforcer:SingletonEnforcer )
		{
			if (!$enforcer)
			{
				throw new Error(new Error("Class Pingback cannot be instantiated. Please call getInstace() method."));
			}
		}
		
		/**
		 * 初始化Pingback
		 * @param parameters flashVars参数
		 */		
		public function initialize(parameters:Object):void
		{
			_parameters = parameters;
		}
		
		
		/**
		 * 获取实例
		 * <br/>
		 * 目前使用单例模式
		 */
		public static function getInstance():Pingback
		{
			if( !_instance ) _instance = new Pingback( new SingletonEnforcer() ) ;
			return _instance ;
		}
		
		/**
		 * 打印exectime类型日志
		 * @param op 操作字符串，尽量使用该字段作为主键
		 * @param module 模块儿字符串
		 * @param code 状态码字符串
		 * @param extra 可以新增任意字段
		 * @param level log等级，范围[0, 7]，默认=6（info），超出范围的会被强制设置成7（debug）
		 * 					<br/>log中传入_l的时候会覆盖此参数
		 * @param channel log频道，默认处理中即为存储的表名，log中传入_c的时候会覆盖此参数
		 */		
		public function logTime(op:String, module:String="", code:String="", extra:Object=null, level:int=6, channel:String=null):void
		{
			log("exectime", op, module, code, extra, level, channel);
		}
		
		/**
		 * 打印notify类型日志
		 * @param op 操作字符串，尽量使用该字段作为主键
		 * @param module 模块儿字符串
		 * @param code 状态码字符串
		 * @param extra 可以新增任意字段
		 * @param level log等级，范围[0, 7]，默认=6（info），超出范围的会被强制设置成7（debug）
		 * 					<br/>log中传入_l的时候会覆盖此参数
		 * @param channel log频道，默认处理中即为存储的表名，log中传入_c的时候会覆盖此参数
		 */		
		public function logNotify(op:String, module:String="", code:String="", extra:Object=null, level:int=6, channel:String=null):void
		{
			log("notify", op, module, code, extra, level, channel);
		}
		
		private function log(type:String, op:String, module:String, code:String, extra:Object, level:int, channel:String):void
		{
			var flashId:String = (_parameters == null ? null : _parameters.flashId);
			var appId:String = (_parameters == null ? null : _parameters.appId);
			var flashUrl:String = (_parameters == null ? null : _parameters.flashUrl);
			
			var tl:Object = {};
			tl.fla = flashId;
			tl.app = (appId == null ? flashId : appId);
			tl.target = flashUrl;
			tl.op = op;
			tl.module = module;
			tl.code = code;
			tl.type = type;
			if(extra != null)
			{
				for(var key:String in extra)
				{
					if(extra[key] != null)
					{
						tl[key] = extra[key];
					}
				}
			}
			this.startPingBack(tl, level, channel);
		}
		
		/** 
		 * 记录远程日志
		 * @param $vo 		log信息object，注意可获取的属性只有该对象的可遍历属性，以及PingbackVO中公开的属性
		 * 					<br/>_log, _l, _c 三个属性请勿使用，会被忽略，参见其他参数
		 * @param level		log等级，范围[0, 7]，默认=6（info），超出范围的会被强制设置成7（debug）
		 * 					<br/>log中传入_l的时候会覆盖此参数
		 * @param channel	log频道，默认处理中即为存储的表名，log中传入_c的时候会覆盖此参数
		 */
		public function startPingBack( $vo:Object, level:int = 6, channel:String = null ):void
		{
			var dp:Object = { } ;
			
			var key:*;
			
			// common data
			for (key in commonData)
			{
				dp[key] = commonData[key];
			}
			
			// static（只接受PingbackVO中定义的）
			for each (var name:String in _VO_PROPS)
			{
				if ($vo.hasOwnProperty(name) && $vo[name] != null)
				{
					dp[name] = $vo[name];
				}
			}
			
			// dynamic
			for (key in $vo)
			{
				dp[key] = $vo[key];
			}
			
			// reserved
			if (dp.hasOwnProperty("_l") && typeof dp._l=="number" && int(dp._l)==dp._l) {
				level = int(dp._l);
			}
			if (level < 0 || level > 7) level = 7;
			delete dp._l;
			if (dp.hasOwnProperty("_c") && typeof dp._c=="string") {
				channel = dp._c;
			}
			delete dp._c;
			delete dp._log;
			
			// 在最后添加一个超级随机数来区别每一次的日志发送
			dp.log_random_num = this.generateID();
			
			start( dp, level, channel) ;
		}
		
		private function start( $dp:Object, level:int, channel:String ):void
		{
			try
			{
				if (_handler != null)
				{
					var args:Array = [$dp, level, channel].slice(0, _handler.length);
					_handler.apply(null, args);
				}
				else
				{
					defaultHandler($dp, level, channel);
				}
			}
			catch( $err:Error )
			{
				trace( "when calling pingback handler, there is an error: " + $err.message ) ;
			}
		}
		
		private function generateID():String
		{
			var timestamp:Number = new Date().time;
			var rnd:Number = Math.random() * 100000000000000000;
			var id:String = timestamp.toString(36) + "_" + rnd.toString(36);
			return id;
		}
		
		/**
		 * 默认处理函数
		 * 调用js发送
		 * 忽略_c和_l属性
		 */
		private function defaultHandler( $dp:Object, level:int, channel:String ):void
		{
			// 设置表名
			if(channel != null) $dp.collection = channel;
			
			var json:String = JSON.stringify( $dp );
			trace("[Pingback] [l="+level+"] [c="+channel+"] " + json);
			
			if(ApplicationDomain.currentDomain.hasDefinition("com.junkbyte.console::Cc"))
			{
				var Cc:* = getDefinitionByName("com.junkbyte.console::Cc");	
				if(Cc) Cc.logch("log", json);
			}
			var escapeResult:String = escape( json ) ;
			//var parseResult:Object = JSON.parse( escapeResult ) ;
			if(ExternalInterface.available) ExternalInterface.call( JSPingbackFun, $dp ) ;
		}
		
		
		/**
		 * log处理函数，参数列表：log对象(Object), log等级(默认=6)，log频道名
		 * <br>
		 * 没有传入的情况下，默认调用js方法"window.voxLogger.log"
		 * <br><br>
		 * 注意：如果自己发送log，需要自己处理以下字段：
		 * <br>_c：库/表名，默认vox_flash:flash
		 * <br>_l：级别，默认info
		 * <br>uid：用户id
		 * <br>_t：时间戳，这里是用来防止ie不重复请求的，没有需要可以不加
		 */
		public function get handler():Function
		{
			return _handler;
		}
		public function set handler(value:Function):void
		{
			if (value != null)
			{
				if (value.length < 1 || value.length > 3)
				{
					throw new ArgumentError("pingback handler should have exectly 1~3 parameter");
				}
			}
			_handler = value;
		}
	}
}
class SingletonEnforcer{}