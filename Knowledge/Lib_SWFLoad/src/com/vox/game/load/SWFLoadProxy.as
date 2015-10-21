package com.vox.game.load
{
	import com.vox.gospel.pingback.Pingback;
	import com.vox.gospel.utils.LoadUtil;
	import com.vox.gospel.utils.PathUtil;
	import com.vox.gospel.utils.StringUtils;
	import com.vox.gospel.utils.VersionUtil;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	
	import spark.primitives.Path;

	/**
	 * swf文件加载代理
	 * @author 肖建军
	 */
	public class SWFLoadProxy
	{
		//----------------------------------------attrs 0 const--------------------------------------------------//
		
		//----------------------------------------attrs 1 ui-----------------------------------------------------//
		
		//----------------------------------------attrs 2 status-------------------------------------------------//
		private var _loadType                   :String = "";
		/**正在加载*/
		private var _loading                    :Boolean = false;
		/**游戏应用是否加载完成*/
		private var _gameInitOK                 :Boolean = false;
		//----------------------------------------attrs 3 data---------------------------------------------------//
		private var _parameters                 :Object;
		private var _loaders                    :Array;
		/**加载次数*/
		private var _loadCount                  :int = 0;
		private var _gameURL                    :String;
		
		//----------------------------------------attrs 4 model--------------------------------------------------//
		private var _handler                    :ISWFLoadProxyHandler ;
		/**缓存Timer*/
		private var _cacheTimer                 :Timer;
		/**心跳Timer*/
		private var _heartBeatTimer             :Timer;
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
			if( _loading ) return ;
			_loading = true ;
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
				loadLibByURLs();
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
			_configStr = $data ;
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
					VersionUtil.toVersionUrls( _configSwfURLArr, getVertionUrlCbkHandler ) ;
				}
			}
		}
		
		private function getVertionUrlCbkHandler( $dict:Object ):void
		{
			loadLibByURLs( $dict( _configSwfURLArr[ 0 ] ), $dict( _configSwfURLArr[ 1 ] ), $dict( _configSwfURLArr[ 2 ] ) ) ;
		}
		
		private function loadLibByURLs( $gameUrl:String, $logiceUrl:String, $engineUrl:String ):void
		{
			
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
		
		
		//----------------------------------------funs 3 listener------------------------------------------------//
		/**
		 * 每隔100毫秒记录一下当前进度
		 * @param event
		 */
		private function onCacheTimer(event:TimerEvent):void
		{
			
		}
		
		
		//----------------------------------------funs 4 tool ---------------------------------------------------//
		private function generateID():String
		{
			var timeStamp:Number = new Date().time ;
			var rnd:Number = Math.random() * 100000000000000;
			var id:String = timeStamp.toString( 36 ) + "_" + rnd.toString( 36 ) ;
			return id ;
		}
		
		//----------------------------------------funs 5 dispose-------------------------------------------------//
		

	}
}