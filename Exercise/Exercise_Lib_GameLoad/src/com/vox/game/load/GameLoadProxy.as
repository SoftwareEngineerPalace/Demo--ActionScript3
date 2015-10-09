package com.vox.game.load
{
	import com.jason.logtool.pingback.Pingback;
	import com.vox.gospel.utils.PathUtil;
	
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.media.SoundMixer;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	/**
	 * 加载代理
	 * @author jishu
	 */
	public class GameLoadProxy
	{
		//----------------------------------------attrs 0 const--------------------------------------------------//
		
		//----------------------------------------attrs 1 ui-----------------------------------------------------//
		
		//----------------------------------------attrs 2 status-------------------------------------------------//
		private var _loading                    :Boolean = false;
		private var _gameInitOK                 :Boolean = false;
		private var _hasBGMusic                    :Boolean = true;
		
		//----------------------------------------attrs 3 data---------------------------------------------------//
		private var _startLoadTime              :int = 0;
		private var _handler                    :ILoadProxyHandler;
		private var _parameters				  :Object;
		private var _gameURL                     :String;
		private var _cacheCount                  :int = 0;
		/**上次记录的加载进度，100是满进度*/
		private var _lastRecordProgress          :int = 0;
		/**加载的进度, 100是满进度 肖建军@2015年7月3日*/
		private var _progress                    :int = 0;
		private var _vGame                       :String;
		private var _vCreater                    :String;
		private var _url                         :String = "";
		private var _curIndex                    :int;
		private var _totalNum                    :int;
		private var _loadType                    :String = "";
		private var _loadCount                   :int = 0;
		private var _loadProcessID               :String;
		
		//----------------------------------------attrs 4 model--------------------------------------------------//
		private var _loaders                    :Array;
		private var _loaderContext              :LoaderContext;
		private var _cacheTimer                 :Timer ;
		private var _heartBeatTimer             :Timer;
	
		
		//----------------------------------------attrs 5 getter setter------------------------------------------//
		/**
		 * 获取加载上下文
		 * @return 
		 */
		public function get loaderContext():LoaderContext
		{
			return _loaderContext ;
		}
		
		/**
		 * 是否有背景音乐
		 */
		public function get hasBGMusic():Boolean
		{
			return _hasBGMusic ;
		}
		
		/**
		 * 是否有背景音乐
		 */
		public function set HasBGMusic( $value:Boolean ):void
		{
			if( $value == _hasBGMusic ) return ;
			_hasBGMusic = $value ;
			
		}
		
		//----------------------------------------funs 0 API-----------------------------------------------------//
		/**
		 * @param $stage 舞台引用
		 * @param $handler 处理对象
		 * @param $parameters flashvars参数
		 * @param $loadType
		 */
		public function GameLoadProxy( $stage:Stage, $handler:ILoadProxyHandler, $parameters:Object=null, $loadType:String = "Preloader"):void
		{
			if( !$stage ) throw new Error("没有stage");
			_handler = $handler ;
			
			//1 将flashvars里的parameters中的参数合并
			_parameters = $stage.loaderInfo.parameters ;
			
			//2 初始化PathUtils
			PathUtil.initialize( _parameters ) ;
			
			//3 把两个parameters来源合并
			for( var key:* in $parameters )
			{
				var value:* = $parameters[ key ]; 
				if( value!= null )
				{
					_parameters[ key ] = value.toString();
				}
			}
			
			//4 存下加载类型
			_loadType = $loadType ;
			
			//5 更新日志的parameters
			Pingback.getInstance().initialize( _parameters ) ;
			
			//6 更新加载器
			_loaders = [] ;
			
			//7 初始化缓存Timer
			_cacheTimer = new Timer( 100 ) ;
			_cacheTimer.addEventListener( TimerEvent.TIMER, onCacheTimer ) ;
			
			//8 初始化心跳日志
			_heartBeatTimer = new Timer( 20000, 3 ) ;
			
		}
		
		
		//----------------------------------------funs 1 init-----------------------------------------------------//
		
		
		
		//----------------------------------------funs 2 process-------------------------------------------------//
		/**
		 * 开始加载流程 
		 * @param $gameUrl 实际游戏的的路径，不传递则使用flashVars中的flashUrl加载
		 */
		public function startLoad( $gameURL:String = null ):void
		{
			if( _loading ) return ;
			_loading = true ;
			_gameInitOK = false ;
			_loadCount ++ ;
			_curIndex = 0 ;
			_gameURL = $gameURL ;
			PathUtil.initialize( _parameters ) ;
			
			//1 初始化LoaderContext
			_loaderContext = new LoaderContext( false, new ApplicationDomain() ) ;
		}
		
		private function onGameInitOK(event:Event):void
		{
			_gameInitOK = true ;
			//更新背景音乐
			updateHasBGMusic( ) ;
		}
		
		private function onGameResult( $evt:Event ):void
		{
			if( _handler != null )
			{
				var result:Object = $evt[ "result" ] ;
				var level:int = result.level ;
				var succss:Boolean = ( result.succss == "true" ) 
				var vitality:int = result.vitality ;
				_handler.onGameEnd() ;
			}
			this.dispose() ;
		}
		
		
		//----------------------------------------funs 3 listener------------------------------------------------//
		private var _loadLibTimeoutId:uint = 0;
		private function onLoadProgress( $evt:ProgressEvent ):void
		{
			// 启动超时计时器
			if(_loadLibTimeoutId > 0) clearTimeout( _loadLibTimeoutId ) ;
			_loadLibTimeoutId = setTimeout( onGameLoadTimeout, 20000 ) ;
			// 记录进度
			_progress = int( $evt.bytesLoaded / $evt.bytesTotal * 100 ) ;
			// 调用回调
			if(_handler != null) _handler.onLoadProgress( _url, _curIndex, _totalNum, $evt.bytesLoaded, $evt.bytesTotal ) ;
		}
		
		private function onHeartBeat( $evt:TimerEvent ):void
		{
			logTime(_loadType, "LoadHeartBeat", null, 
				{ i0: _heartBeatTimer.currentCount * 20000,
				  loadProcessID: _loadProcessID
				}
			);
		}
		
		/**
		 * 每隔100毫秒记录一下当前进度
		 * @param event
		 */
		private function onCacheTimer(event:TimerEvent):void
		{
			if(_cacheTimer.currentCount == 1) 
			{
				_lastRecordProgress = _progress ;
				_cacheCount = 0;
			}
			else
			{
				if(_lastRecordProgress != _progress && _progress != 100)
				{
					_cacheCount ++ ;
					_lastRecordProgress = _progress ;
				}
			}
		}
		
		private function onLoadError( $evt:Event ):void
		{
			if( $evt is IOErrorEvent ) onLoadIOError( $evt as IOErrorEvent ) ;
			else if( $evt is SecurityDomain ) onloadSecurityError( $evt as SecurityErrorEvent ) ;
		}
		
		private function onLoadIOError( $evt:IOErrorEvent ):void
		{
			if( _loadLibTimeoutId > 0 ) 
			{
				clearTimeout( _loadLibTimeoutId ) ;
			}
			
			_loading = false ;
			stopBeartHeart();
			
			logTime( _loadType, "LoadFailled", "io_error",
				{
					i0:getTimer() - _startLoadTime ,
					i1: _loadCount , 
					s1: $evt.text ,
					loadProcessID: _loadProcessID 
				} ) ;
			if( _handler != null )
			{
				_handler.onLoadError( $evt ) ; 
			}
		}
		
		private function onloadSecurityError( $evt:SecurityErrorEvent ):void
		{
			if( _loadLibTimeoutId > 0 ) clearTimeout( _loadLibTimeoutId ) ;
			_loading = false ;
		    stopBeartHeart() ;
			logTime( _loadType, "LoadFailed", "security_error",{
					"i0": getTimer() - _startLoadTime, "i1": _loadType,  "s1": $evt.text, "loadProgressID": _loadProcessID  });
		
			if( _handler != null )
			{
				_handler.onLoadError( $evt ) ;
			}
		}
		
		
		//----------------------------------------funs 4 tool ---------------------------------------------------//
		private function onUncaughtError( $evt:UncaughtErrorEvent ):void
		{
			$evt.stopPropagation() ;
			var json:String = "";
			var code:String = "";
			if( _parameters != null )
			{
				json = _parameters.json ;
				code = _parameters.flashId + "," + _parameters.appId ;
			}
			var regCode:RegExp = /Error #(\d+)/ ; 
			var regCodeResult:Object; 
			var errorType:String ;
			var errorCode:int = 0 ;
			var errorMessage:String ;
			var errorStackTrace:String = $evt.error.getStackTrace();
			if( $evt.error is Error )
			{
				var error:Error = $evt.error as Error ;
				errorType = "Error" ;
				errorCode = error.errorID ;
				errorMessage = error.message ;
				if( !errorStackTrace )
				{
					errorStackTrace = $evt.error.getStackTrace();
				}
				if( errorCode <= 0 )
				{
					regCodeResult = regCode.exec( error.message ) ;
					if( regCodeResult != null )
					{
						errorCode = int( regCodeResult[1] ) ;
					}
				}
			}
			else if( $evt.error is ErrorEvent )
			{
				var errorEvent:ErrorEvent = $evt.error as ErrorEvent ;
				errorType = "ErrorEvent" ;
				errorCode = errorEvent.errorID ;
				errorMessage = errorEvent.text ;
				if( errorCode <= 0 )
				{
					regCodeResult = regCode.exec( errorEvent.text ) ;
					if( regCodeResult != null )
					{
						errorCode = int( regCodeResult[1] ) ;
					}
				}
			}
			else
			{
				errorType = "Unknown";
				if( $evt.error != null ) 
				{
					errorMessage = String( $evt.error ) ;
					regCodeResult = regCode.exec( $evt.error.toString() ) ;
					if( regCodeResult != null )
					{
						errorCode = int( regCodeResult[ 1 ] ) ;
					}
				}
			}
			
			var capabilities:URLVariables = new URLVariables( Capabilities.serverString ) ;
			logNotify( "UncaughtError", "UNcaughtError", errorType, {
				i0:errorCode,
				s1:errorMessage,
				loadProcessID: _loadProcessID,
				appCode: code,
				json: json,
				stackTrace: errorStackTrace,
				info: capabilities 
			});
		}
		
		private function onRemovedFromStage():void
		{	
			this.dispose() ;
		}
		
		private function onGameLoadTimeout():void
		{
			if( _loadLibTimeoutId > 0 )
			{
				clearTimeout( _loadLibTimeoutId ) ;
				_loadLibTimeoutId = 0 ;
			}
			_loading = false ;
			_cacheTimer.reset() ;
			logTime( _loadType, "LoadTimeout", "timeout", {
				i0:getTimer() - _startLoadTime,
				i1: _loadCount ,
				loadProcessID: _loadProcessID 
			});
			if( !_handler ) _handler.onLoadError( new ErrorEvent( ErrorEvent.ERROR, false, false, "LoadTimeOut"));
		}
		
		private function stopBeartHeart():void
		{
			_heartBeatTimer.removeEventListener( TimerEvent.TIMER, onHeartBeat ) ;	
			_heartBeatTimer.reset() ;
		}
		
		private function onVoxLoggerTracer(event:Event):void
		{
			event.stopPropagation();
			if(event.hasOwnProperty("data"))
			{
				try
				{
					this.traceLog(event["data"]);
				} 
				catch(error:Error) 
				{
				}
			}
		}
		
		
		private function traceLog(log:*):void
		{
			if (typeof log == "object")
			{
				Pingback.getInstance().startPingBack(log);
			}
		}
		
		
		/**
		 * @return 时间戳 + 大随机数
		 */
		private function generateID():String
		{
			var timestamp:Number = new Date().time;
			var randomNumer:Number = Math.random() * 100000000000000000;
			var id:String = timestamp.toString(36) + "_" + randomNumer.toString(36);
			return id;
		}
		
		private function logTime(module:String, op:String, code:String, info:Object=null):void
		{
			log("exectime", module, op, code, info);
		}
		
		private function logNotify(module:String, op:String, code:String, info:Object=null):void
		{
			log("notify", module, op, code, info);
		}
		
		private function updateHasBGMusic():void
		{
			if( !_gameInitOK ) return ;
			//获取小游戏的应用程序域
			var domain:ApplicationDomain = _loaderContext.applicationDomain ;
			//获取其中对ContextManager的定义
			if( !domain.hasDefinition("com.vox.future.managers::ContextManager")) return ;
			var contextManager:Class = domain.getDefinition("com.vox.future.managers::ContextManager") as Class ;
			//通过ContextManager的静态方法获取GameManager的对象引用
			if( !contextManager.context ) return ;
			var gameManager:* = contextManager.context.getObjectByType("com.vox.future.managers::GameManager");
			//设置声音属性
			if( !gameManager ) gameManager.setGameVoice( _hasBGMusic ) ;
		}
		
		//----------------------------------------funs 5 dispose-------------------------------------------------//
		private function dispose():void
		{
			if( !_loaderContext ) return ;	
			while( _loaders.length > 0 )
			{
				var loader:Loader = _loaders.pop() ;
				loader.contentLoaderInfo.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError ) ;
			}
			_loaderContext = null ;
			_cacheTimer.reset() ;
			_cacheTimer.removeEventListener( TimerEvent.TIMER, onCacheTimer ) ;
			_cacheTimer = null ;
			
			_heartBeatTimer.reset(); 
			_heartBeatTimer.removeEventListener( TimerEvent.TIMER, onHeartBeat ) ;
			_heartBeatTimer = null ;
			
			_handler = null ;
			_parameters = null ;
			
			//关闭所有声音
			SoundMixer.stopAll() ;
			//显示鼠标(有些游戏里会隐藏鼠标)
			Mouse.show() ;
		}
		
		//----------------------------------------funs 6 日志系统-------------------------------------------------//
		private function log( $type:String, $module:String, $op:String, $code:String, $info:Object = null ):void
		{
			var flashId:String = _parameters.flashId ;
			var appId:String = _parameters.appId ;
			
			var tl:Object = {};
			tl.type = $type ;
			tl.app = ( appId == null ? flashId : appId ) ;
			tl.module = $module ;
			tl.op = $op ;
			tl.code = $code ;
			tl.target = _url ;
			if( $info ) 
			{
				for( var key:String in $info )
				{
					if( $info[ key ] != null )
					{
						tl[ key ] = $info[ key ] ;
					}
				}
			}
			
			if( _parameters.flashId == _parameters.appId || _parameters.flashUrl == _parameters.appUrl )
			{
				tl.flashType = "tiny" ;
			}
			else
			{
				tl.flashType = "framework"
			}
			Pingback.getInstance().startPingBack( tl ) ;
		}
	}
}