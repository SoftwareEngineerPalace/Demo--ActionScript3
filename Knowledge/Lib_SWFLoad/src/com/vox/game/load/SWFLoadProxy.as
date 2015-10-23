package com.vox.game.load
{
	import com.vox.gospel.pingback.Pingback;
	import com.vox.gospel.utils.LoadUtil;
	import com.vox.gospel.utils.PathUtil;
	import com.vox.gospel.utils.StringUtils;
	import com.vox.gospel.utils.URLUtil;
	import com.vox.gospel.utils.VersionUtil;
	
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
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import spark.primitives.Path;

	/**
	 * swf文件加载代理
	 * @author 肖建军
	 */
	public class SWFLoadProxy
	{
		//----------------------------------------attrs 0 const--------------------------------------------------//
		private const LogType_ExecTime          :String = "exectime";
		private const LogType_Notify            :String = "notify";
		
		/**操作： 开始加载*/
		private const LogOp_LoadStart           :String = "LoadStart";
		/**操作： 加载成功*/
		private const LogOp_LoadComplete        :String = "LoadComplete" ;
		/**操作： 心跳*/
		private const LogOp_LoadHeartBeat       :String = "LoadHeartBeat";
		/**操作: 加载失败*/
		private const LogOp_LoadFailed          :String = "LoadFailed";
		/**操作: UncaughtError*/
		private const LogOp_UncaughtError       :String = "UncaughtError";
		/**操作: 加载超时*/
		private const LogOp_LoadTimeout         :String = "LoadTimeout";
		
		
		/**超时毫秒时长*/
		private const TimeoutMS                 :Number = 20000 ;
		//----------------------------------------attrs 1 ui-----------------------------------------------------//
		
		//----------------------------------------attrs 2 status-------------------------------------------------//
		private var _loadType                   :String = "" ;
		/**正在加载*/
		private var _beLoading                  :Boolean = false ;
		/**游戏应用是否加载完成*/
		private var _gameInitOK                 :Boolean = false ;
		
		//----------------------------------------attrs 3 data---------------------------------------------------//
		private var _parameters                 :Object ;
		private var _loaders                    :Array ;
		/**加载次数*/
		private var _loadCount                  :int = 0 ;
		/**实际目标小游戏的路径*/
		private var _gameURL                    :String ;
		/**什么的总数 ?*/
		private var _LoaderTotalNum                   :int ;
		private var _curLoadingUrl              :String ;
		private var _curLoadItemIndex           :uint ;
		private var _timeoutFlag                :int ;
		/**开始加载的时间戳 肖建军@2015-10-22*/
		private var _startLoadTime              :Number ;
		/**缓存记数 */
		private var _cacheCount                 :int = 0;
		/**加载的 id 肖建军@2015-10-22*/
		private var _loadProcessID              :String ;
		/**当前进度*/
		private var _curProgress                :int ;
		/**上一次记录的进度*/
		private var _lastRecordProgress         :int = 0;
		
		//----------------------------------------attrs 4 model--------------------------------------------------//
		private var _handler                    :ISWFLoadProxyHandler ;
		/**缓存Timer*/
		private var _cacheTimer                 :Timer;
		/**心跳Timer*/
		private var _heartBeatTimer             :Timer;
		/**加载上下文*/
		private var _loaderContext              :LoaderContext;
	
		
		//----------------------------------------attrs 5 getter setter------------------------------------------//
		
		
		//----------------------------------------funs 0 API-----------------------------------------------------//
		public function SWFLoadProxy( $stage:Stage, $handler:ISWFLoadProxyHandler, $param:Object = null, $loadType:String = "Preloader" )
		{
			if( !$stage ) throw new Error("stage引用为null");
			//1 存加载器
			_handler = $handler ; 
			//2 存加载方式
			_loadType = $loadType ;
			//3 将 flashvars 与 parameters 中的参数合并
			_parameters = $stage.loaderInfo.parameters ;
			for( var key:* in _parameters ) 
			{
				var value:* = _parameters[ key ] ;
				if( value != null )
				{
					_parameters[ key ] = value.toString();
				}
			}
			//4 更新Path的参数
			PathUtil.initialize( _parameters ) ;
			//5 更新远程日程的parameters
			Pingback.getInstance().initialize( _parameters ) ;
			//6 加载数组
			_loaders = [];
			//7 初始化缓存Timer
			_cacheTimer = new Timer( 100 ) ;
			_cacheTimer.addEventListener( TimerEvent.TIMER, onCacheTimer )　;
			//8 初始化心跳日志系统
			_heartBeatTimer = new Timer( 20000, 3 ) ;
		}
		
		/**
		 * 开始加载流程 
		 * @param $gameUrl 实际游戏的路径，不传递则使用flashVars中的flashUrl来加载
		 */
		public function startLoad( $gameUrl:String = null ):void
		{
			// 1 当前是否正在加载的flag
			if( _beLoading ) return ;
			_beLoading = true ;
			// 2 游戏是否已经初始化完毕
			_gameInitOK = false ;
			// 3 加载次数
			_loadCount ++ ;
			// 4 存入gameUrl
			_gameURL = $gameUrl ;
			// 5 初始化PathUtils  这个感觉有点多余啊
			PathUtil.initialize( _parameters ) ;
			// 7 初始化LoaderContext
			_loaderContext = new LoaderContext( false ,new ApplicationDomain() ) ;
			_loaderContext.allowCodeImport = true ;
			_loaderContext.parameters = _parameters ;
			// 8 开始加载库
			this.startLoadLib();
			// 9 调用onLoadStart
			if( _handler != null ) _handler.onLoadStart() ;
			// 10 记录时间戳
			_startLoadTime = getTimer() ;
			// 11 生成加载进程ID
			_loadProcessID = getGenerateID() ;
			// 12 启动超时计时器
			startTimeout( true ) ;
			// 13 启动心跳计时器
			runHeartBeatTimer( true ) ;
			// 14 打日志
			var json:Object ;
			if( _parameters != null ) 
			{
				try
				{
					json = JSON.parse( _parameters.json ) ;
				} 
				catch(error:Error) 
				{
					json = null ;
				}
				_curLoadingUrl = getValidUrlInTurn([ _gameURL, _parameters.flashURL, _parameters.flashUrl ]);
			}
			var capabilities:URLVariables = new URLVariables( Capabilities.serverString ) ;
			startPingback( LogType_Notify, _loadType, LogOp_LoadStart, null, 
				{
					i1: _loadCount,
					loadProcessID: _loadProcessID,
					json: json,
					info: capabilities 
				});
		}
		
		//----------------------------------------funs 1 init-----------------------------------------------------//
		
		
		
		//----------------------------------------funs 2 process-------------------------------------------------//
		private function startLoadLib():void
		{
			var flashLogicUrl:String = _parameters.flashLogicUrl ;
			var flashEngineUrl:String = _parameters.flashEngineUrl ;
			var flashGameCoreUrl:String = _parameters.flashGameCoreUrl ;
			if( flashGameCoreUrl == null )
			{
				//使用config.ini文件加载库
				loadLibByFile();
			}
			else
			{
				loadLibByURLs( flashGameCoreUrl, flashLogicUrl, flashEngineUrl ) ;
			}
		}
		
		//--------------------------------------------使用config.ini文件加载库----------------------------------------------------
		private var _configStr:String ; 
		/**使用config.ini文件加载库主方法*/
		private function loadLibByFile():void
		{
			//加载config.ini
			loadConfigURLINI();
		}
		
		private function loadConfigURLINI():void
		{
			var url:String = PathUtil.wrapFlashURL( "future/config-V20" + new Date().time + ".ini" );
			LoadUtil.urlLoaderLoad( url, onUrlLoaderLoadCompleteHandler, onUrlLoaderLoadErrorHandler ) ;
		}
		
		private function onUrlLoaderLoadCompleteHandler( $data:Object ):void
		{
			//_configStr = $data ;
			loadLib_mainProcess();
		}
		
		private var _configSwfURLArr:Array = [];
		private function loadLib_mainProcess():void
		{
			var isFutureGame:Boolean = false ;
			var configList:Array = _configStr.split("\r\n");
			for (var i:int = 0, len:uint = configList.length; i < len; i++) 
			{
				var lineList:Array = configList[ i ].split(",");
				var gameName:String = StringUtils.trim( lineList[ 0 ] ) ;
				if( gameName == _parameters.flashId )
				{
					isFutureGame = true ;
					_configSwfURLArr = [];
					var gameSwfName:String = "future/game.swf";
					_configSwfURLArr.push( gameSwfName ) ;
					var logicName:String = null ;
					var engineName:String = null ;
					if( lineList[ 1 ] != null )
					{
						logicName = "future/logics/" + StringUtils.trim( lineList[1] ) +　".swf" ;
						_configSwfURLArr.push( logicName ) ;
					}
					if( lineList[ 2 ] != null )
					{
						engineName = "future/gameengines/" + StringUtils.trim( lineList[2] ) + ".swf" ;
						_configSwfURLArr.push( engineName ) ;
					}
					//向服务器请求最新的文件路径
					VersionUtil.toVersionUrls( _configSwfURLArr, getVertionUrlCbkHandler ) ;
				}
			}
		}
		
		/**向服务器请求最新的文件路径的回调*/
		private function getVertionUrlCbkHandler( $dict:Object ):void
		{
			loadLibByURLs( $dict( _configSwfURLArr[ 0 ] ), $dict( _configSwfURLArr[ 1 ] ), $dict( _configSwfURLArr[ 2 ] ) ) ;
		}
		
		private var _loadUrlArr:Array ;
		/**知道多个lib swf的url地址，然后依次加载*/
		private function loadLibByURLs( $gameUrl:String, $logiceUrl:String, $engineUrl:String ):void
		{
			_loadUrlArr = [];
			//获取Logic的地址及版本号
			if( $logiceUrl != null )
			{
				CONFIG::RELEASE
				{
					if( _loadCount > 1 )
					{
						//如果不是第一次加载，则给logic swf加上版本号
						$logiceUrl = URLUtil.addVersion( $logiceUrl, String( new Date().time ) ) ;
					}
				}
				_loadUrlArr.push( $logiceUrl ) ;
			}
			
			//获取Engine的地址及版本号
			if( $engineUrl != null )
			{
				CONFIG::RELEASE
				{
					if( _loadCount > 1 )
					{
						$engineUrl = URLUtil.addVersion( $engineUrl, String( new Date().time ) ) ;
					}
				}
				_loadUrlArr.push( $engineUrl ) ;
			}
			
			//如果appId有值，且appId和flashId不等,  表示是框架游戏， 去直接加载 游戏目标swf 肖建军不明白@2015-10-23
			if( _parameters.appId != null && _parameters.flashId != _parameters.appId )
			{
				_LoaderTotalNum = 1 ;
				startLoadMainGameSwf();
			}
			else
			{
				_curLoadingUrl = $gameUrl ;
				CONFIG::RELEASE
				{
					if( _loadCount > 1 )
					{
						_curLoadingUrl = URLUtil.addVersion( _curLoadingUrl, String( new Date().time ) ) ;
					}
				}
				_loadUrlArr.unshift( _curLoadingUrl ) ;
				_LoaderTotalNum = _loadUrlArr.length + 1 ;
				loadOne();
			}
		}
		
		private function loadOne( $loader:Loader = null ):void
		{
			if( $loader != null )
			{
				_curLoadItemIndex ++ ;
				$loader.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError ) ;
				_loaders.push( $loader )　;
			}
			
			if( _loadUrlArr && _loadUrlArr.length == 0 )
			{
				onLoadLibComplete() ;
			}
			else
			{
				_curLoadingUrl = _loadUrlArr.shift() ;
				LoadUtil.loaderLoadWithoutSandbox( _curLoadingUrl, loadOne, onLoadError, onLoadProgress, _loaderContext ) ;
			}
		}
		
		private function onLoadLibComplete():void
		{
			startTimeout( false ) ;
			_cacheTimer.reset() ;
			startLoadMainGameSwf() ;
		}
		
		private function onUrlLoaderLoadErrorHandler( $evt:Event ):void
		{
			if( $evt is IOErrorEvent )
			{
				
			}
			else if(　$evt is SecurityErrorEvent )
			{
				
			}
		}
		
		/**正式开始加载 game swf 肖建军@2015-10-22*/
		private function startLoadMainGameSwf():void
		{
			_curLoadingUrl = getValidUrlInTurn([_gameURL, _parameters.flashUrl, _parameters.flashURL])
			CONFIG::RELEASE
			{
				if( _loadCount > 1 )
				{
					_curLoadingUrl = URLUtil.addVersion( _curLoadingUrl, String( new Date().time ) ) ;
				}
			}
			LoadUtil.loaderLoadWithoutSandbox( _curLoadingUrl,
				onLoadTargetGameComplete, 
				onUrlLoaderLoadErrorHandler,
				onLoadProgress,
				_loaderContext ) ;
			
			//启动缓存计时器
			_cacheTimer.reset() ;
			_cacheTimer.start() ;
		}
		
		
		//----------------------------------------funs 3 listener------------------------------------------------//
		/**
		 * 每隔100毫秒记录一下当前进度
		 * @param event
		 */
		private function onCacheTimer(event:TimerEvent):void
		{
			if( _cacheTimer.currentCount == 1 )
			{
				_lastRecordProgress = _curProgress ;
				_cacheCount = 0 ;
			}
			else
			{
				if( _lastRecordProgress != _curProgress && _curProgress != 100 )
				{
					_cacheCount ++ ;
					_lastRecordProgress = _curProgress ;
				}
			}
		}
		
		private function onLoadTargetGameComplete( $loader:Loader ):void
		{
			_curLoadItemIndex ++ ;
			//1 IE浏览器里中途断网可能也会走Complete事件，所以要确保加载完全成功才行.
			if( $loader.contentLoaderInfo.bytesLoaded <　$loader.contentLoaderInfo.bytesTotal )
			{
				var evt:IOErrorEvent = new IOErrorEvent( IOErrorEvent.NETWORK_ERROR, false, false, "可能是IE Bug, 中途断网后仍然走了Complete事件" );
				onLoadIOError( evt ) ;
				return ;
			}
			
			//2 清除timeoutFlag
			if( _timeoutFlag > 0 )
			{
				clearTimeout( _timeoutFlag ) ;
				_timeoutFlag = 0 ;
			}
			
			//3 设置加载状态为false
			_beLoading = false ;
			
			//4 重置 缓存Timer
			_cacheTimer.reset() ;
			
			//5 停止心跳
			runHeartBeatTimer( false ) ;
			
			//6 打印log
			startPingback( LogType_Notify, //log type
				_loadType, //module 
				LogOp_LoadComplete, //op
				null,
				{ i0:getTimer() - _startLoadTime,
				i1: _cacheCount,
				s1: _parameters.studyType,
				loadProcessID: _loadProcessID });
			
			//7 补充一些操作
			if( $loader.content )
			{
				$loader.content.addEventListener( "IntializeComplete", onGameIntializeSuccessfulCbk ) ;
				$loader.content.addEventListener( "AftGameResultDis", onGameResultHandler ) ;
				$loader.content.addEventListener( Event.REMOVED_FROM_STAGE, onContentOffStagedHandler ) ;
				$loader.content.addEventListener( "VoxLoggerTracer", onVoxLoggerTracer ) ;
				//设置加载器进程id
				if( $loader.content.hasOwnProperty("loadProcessID"))
				{
					$loader.content["loadProcessID"] = _loadProcessID ;
				}
			}
			
			//8 监听未抓取错误
			$loader.contentLoaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError ) ;
			_loaders.push( $loader ) ;
			if( _handler != null ) _handler.onLoadComplete( $loader ) ;
		}
		
		private function onUncaughtError( $evt:UncaughtErrorEvent ):void
		{
			$evt.stopPropagation() ;
			var json:String = "" ;
			var code:String = "" ;
			if( _parameters != null )
			{
				json = _parameters.json ;
				code = _parameters.flashId + "," + _parameters.appId ;
			}
			//取错误类型和错误ID
			var regCode:RegExp = /Error #(\d+)/ ;
			var regCodeResult:Object ;
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
					if( regCodeResult != 0 )
					{
						errorCode = int( regCodeResult[ 1 ] ) ;
					}
				}
			}
			else
			{
				errorType = "Unknown" ;
				if( $evt.error != null )
				{
					errorMessage = String( $evt.error ) ;
					regCodeResult = regCode.exec( $evt.error.toString ) ;
					if( regCodeResult != null )
					{
						errorCode = int( regCodeResult[ 1 ] ) ;
					}
				}
			}
			//打印日志
			var capabilities:URLVariables = new URLVariables( Capabilities.serverString ) ;
			startPingback( LogType_Notify, LogOp_UncaughtError, LogOp_UncaughtError,"",
				{   i0: errorCode,
					s1: errorMessage,
					loadProcessID: _loadProcessID,
					appCode: code,
					json: json,
					stackTrace: errorStackTrace,
					info: capabilities
				});
		}
		
		private function runHeartBeatTimer( $value:Boolean ):void
		{
			if( !$value )
			{
				_heartBeatTimer.removeEventListener( TimerEvent.TIMER, onBeatHeartHandler ) 
				_heartBeatTimer.reset() ;
			}
			else
			{
				_heartBeatTimer.reset() ;
				_heartBeatTimer.addEventListener( TimerEvent.TIMER, onBeatHeartHandler ) ;
				_heartBeatTimer.start() ;
			}
		}
		
		private function startTimeout( $value:Boolean ):void
		{
			if( _timeoutFlag > 0 ) clearTimeout( _timeoutFlag ) ;
			if( $value )
			{
				_timeoutFlag = setTimeout( onTimeout, TimeoutMS )　;
			}
		}
		
		private function onTimeout():void
		{
			startTimeout( false ) ;
			_beLoading = false ;
			_cacheTimer.reset() ;
			startPingback( LogType_ExecTime, _loadType, LogOp_LoadTimeout, "timeout",
				{
					i0:getTimer() - _startLoadTime,
					i1:_loadCount,
					loadProcessID: _loadProcessID
				});
			if( _handler != null ) _handler.onLoadError( new ErrorEvent( ErrorEvent.ERROR, false, false, LogOp_LoadTimeout ) ) ;
		}
		
		private function onLoadProgress( $evt:ProgressEvent):void
		{
			//启动超时计时器
			startTimeout( true )　;
			
			//记录进度 满进度是100 取整数
			_curProgress = int( $evt.bytesLoaded / $evt.bytesTotal * 100 ) ; 
			//调用回调 
			if( _handler != null ) 
			{
				_handler.onLoadProgress( _curLoadingUrl, _curLoadItemIndex, _LoaderTotalNum, $evt.bytesLoaded, $evt.bytesTotal ) ;
			}
		}
		
		/**游戏初始化成功*/
		private function onGameIntializeSuccessfulCbk( $evt:Event ):void
		{
			_gameInitOK = true ;
			updateBackgroundMusic() ;
		}
		
		/**阿分提游戏，获取到了游戏结果时. */
		private function onGameResultHandler( $evt:Event ):void
		{
			if( _handler != null )
			{
				var result:Object = $evt["result"];
				var level:int = result.level ;
				var success:Boolean = ( result.success == "true" ) ;
				var vitality:int = result.vitality ;
				_handler.onGameEnd( result ) ;
			}
			//销毁自身
			this.dispose();
		}
		
		/**输入输出错误的回调*/
		private function onLoadIOError( $evt:IOErrorEvent ):void
		{
			//1 删除timeout
			startTimeout( false ) ;
			//2 加载状态设为false
			_beLoading = false ;
			//3 停止心跳
			runHeartBeatTimer( false ) ;
			//4 打日志
			startPingback( LogType_ExecTime, _loadType, LogOp_LoadFailed, "io_error",
				{
					i0:getTimer() - _startLoadTime,
					i1: _loadCount ,
					s1: $evt.text ,
					loadProgressID: _loadProcessID
				});
			if( _handler != null )　_handler.onLoadError( $evt ) ;
		}
		
		/**当content从Staging移出时*/
		private function onContentOffStagedHandler( $evt:Event ):void
		{
			//销毁自身
			this.dispose() ;
		}
		
		/**
		 * 心跳TimerHandler
		 * @param $evt
		 */
		private function onBeatHeartHandler( $evt:TimerEvent ):void
		{
			startPingback( LogType_ExecTime, null, LogOp_LoadHeartBeat, null,
				{
					i0: _heartBeatTimer.currentCount * 20000,
					loadProcessID: _loadProcessID 
				});
		}
		
		
		//----------------------------------------funs 4 tool ---------------------------------------------------//
		private function onVoxLoggerTracer( $evt:Event ):void
		{
			$evt.stopPropagation() ;
			if( $evt.hasOwnProperty("data"))
			{
				try
				{
					this.traceLog( $evt["data"]);
				} 
				catch(error:Error) 
				{
					
				}
			}
		}
		
		private function traceLog( $log:* ):void
		{
			if( typeof $log == "object" )
			{
				Pingback.getInstance().startPingBack( $log ) ;
			}
		}
		
		/**错误事件的总回调入口方法*/
		private function onLoadError( $evt:Event ):void
		{
			if( $evt is IOErrorEvent )　onLoadIOError( $evt as IOErrorEvent ) ;
			else if( $evt is SecurityErrorEvent ) onLoadSecurityError( $evt as SecurityErrorEvent ) ;
		}
		
		/**专门处理安全事件的回调*/
		private function onLoadSecurityError( $evt:SecurityErrorEvent ):void
		{
			//清除timeout
			startTimeout( false ) ;
			//加载状态设为false
			_beLoading = false ;
			//停止心跳
			runHeartBeatTimer( false )　;
			//打日志
			startPingback( LogType_ExecTime, _loadType, LogOp_LoadFailed, "security_error",
				{
					i0:getTimer() - _startLoadTime,
					i1: _loadCount,
					s1: $evt.text,
					loadProcessID: _loadProcessID 
				} ) ;
			if( _handler != null ) _handler.onLoadError( $evt ) ;
		}
		
		private var _bgMusicOn:Boolean = true;

		/**是否开启背景音乐*/
		public function get bgMusicOn():Boolean
		{
			return _bgMusicOn;
		}

		/**
		 * @param value 是否开启背景音乐
		 */
		public function set bgMusicOn(value:Boolean):void
		{
			if( value == _bgMusicOn ) return ; //如果状态没变， 则不用设置
			_bgMusicOn = value;
			updateBackgroundMusic() ;
		}

		
		private function updateBackgroundMusic():void
		{
			if( !_gameInitOK ) return ; //如果游戏没有初始完毕，则不执行下面
			var domain:ApplicationDomain = _loaderContext.applicationDomain ;
			//获取其中对ContextManager的定义
			if( !domain.hasDefinition("com.vox.future.manager::ContextManager")) return ;
			var contextManager:Class = domain.getDefinition("com.vox.future.manager::ContextManager") as Class ;
			//通过ContextManager的静态方法获取GameManager的对象引用
			if( !contextManager.context ) return ;
			var gameManager:* = contextManager.context.getObjectByType("com.vox.future.manager::GameManager");
			//设置声音属性
			if( gameManager != null )　gameManager.setGameVoice( _bgMusicOn ) ;
			
		}
		
		/**按顺序获取数组中的有效字符串 肖建军@2015-10-22*/
		private function getValidUrlInTurn( $arr:Array ):String
		{
			var result:String ;
			for (var i:int = 0; i < $arr.length; i++) 
			{
				if( $arr[ i ] != null )
				{
					result = $arr[ i ] ;
					break ;
				}
			}
			return result ;
		}
		
		private function getGenerateID():String
		{
			var timeStamp:Number = new Date().time ;
			var rnd:Number = Math.random() * 100000000000000;
			var id:String = timeStamp.toString( 36 ) + "_" + rnd.toString( 36 ) ;
			return id ;
		}
		
		/**
		 * 打日志
		 * @param $logType 日志类型 notify是记录动作 exectime是记录时长
		 * @param $module 模块 
		 * @param $op     操作动作
		 * @param $code   编码
		 * @param $info   必要信息
		 */
		private function startPingback( $logType:String, $module:String, $op:String, $code:String, $info:Object):void
		{
			var logObj:Object = {};
			//1 log类型
			logObj.type = $logType ;
			//2  应用的名字
			logObj.app = getValidUrlInTurn([ _parameters.appId, _parameters.flashId]);
			//3  模块的名字
			logObj.module = $module ;
			//4 操作动作
			logObj.op = $op ;
			//5 编码
			logObj.code = $code ;
			//6 加载目标的url
			logObj.target = _curLoadingUrl ;
			//7 解析info里的信息存下来
			if( $info )
			{
				for (var i:String in $info) 
				{
					if( $info[ i ] != null )
					{
						logObj[ i ] = $info[ i ] ;
					}
				}
			}
			//8 如果flashI 和 appId 相同则表示当前是小游戏，否则就是游戏框架
			if( _parameters.flashId == _parameters.appId 
				|| _parameters.flashUrl == _parameters.appUrl )
			{
				logObj.flashType = "tiny" ;
			}
			else
			{
				logObj.flashType = "framework" ;
			}
			//9 发送日志
			Pingback.getInstance().startPingBack( logObj ) ;
		}
		
		private function runCacheTimer( $value:Boolean ):void
		{
			if( !$value )
			{
				_cacheTimer.removeEventListener(TimerEvent.TIMER, onCacheTimer ) ;
				_cacheTimer.reset() ;
			}
		}
		
		//----------------------------------------funs 5 dispose-------------------------------------------------//
		private function dispose():void
		{
			if( _loaderContext == null ) return ;
			while( _loaders.length > 0 )
			{
				var loader:Loader = _loaders.pop() ;
				loader.contentLoaderInfo.uncaughtErrorEvents.removeEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError ) ;
			}
			_loaderContext = null ;
			
			//清除cacheTimer
			runCacheTimer( false ) ;
			_cacheTimer = null ;
			
			//清除心跳Timer
			runHeartBeatTimer( false ) ;
			_heartBeatTimer = null ;
			
			//清除其它常量
			_handler = null ;
			_parameters = null ;
			
		   	//关闭所有声音
			SoundMixer.stopAll() ;
			
			//显示鼠标 （因为在一些游戏中会隐藏鼠标）
			Mouse.show() ;
		}
	}
}