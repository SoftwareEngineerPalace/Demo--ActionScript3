package
{
	import com.vox.gospel.locallog.logging.ILogger;
	import com.vox.gospel.locallog.logging.Log;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedSuperclassName;

	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event(name="uncaughtError", type="flash.events.UncaughtErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * flex工程加载器
	 * <br>
	 * 用于手动控制RSL的加载，避免RSL加载失败时默认的处理方式
	 * <br>
	 * 不支持重复调用
	 * @author Helcarin
	 */
	public class VoxFlexLoader extends EventDispatcher
	{
		private static var _logger:ILogger = Log.getLogger("VoxFlexLoader");
		
		private var _loader:URLLoader;
		private var _contentLoader:Loader;
		/** loading rsl requests */
		private var _requests:Array = [];
		
		private var _rslRoot:String;
		
		/**
		 * @param rslRoot 用于替换的rsl地址
		 */
		public function VoxFlexLoader(rslRoot:String)
		{
			_rslRoot = rslRoot;
		}
		
		
		/**
		 * 加载
		 */
		public function load(req:URLRequest):void
		{
			if (!req) throw new ArgumentError("url request cannot be empty");
			if (_loader) close();
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.OPEN, onOpen);
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
			_loader.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			
			log("begin loading: " + req.url);
			_loader.load(req);
		}
		
		
		/**
		 * 关闭当前加载
		 */
		public function close():void
		{
			if (_loader)
			{
				_loader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_loader.removeEventListener(Event.COMPLETE, onComplete);
				try {
					_loader.close();
				}
				catch (err:Error) {}
				
				_loader = null;
			}
			
			if (_contentLoader)
			{
				_contentLoader.contentLoaderInfo.removeEventListener(Event.INIT, onContentInit);
				_contentLoader.unloadAndStop();
				
				_contentLoader = null;
			}
			
			_requests = [];
		}
		
		
		/**
		 * on open
		 */
		private function onOpen(event:Event):void
		{
			log("--- on open");
		}
		
		
		/**
		 * on progress
		 */
		private function onProgress(event:Event):void
		{
			log("--- on progress");
			dispatchEvent(event);
		}
		
		/**
		 * on security error
		 */
		private function onSecurityError(event:Event):void
		{
			log("--- on secutity error");
			dispatchEvent(event);
		}
		
		/** on ioError */
		private function onIOError(event:IOErrorEvent):void
		{
			log("--- on io error");
			dispatchEvent(event);
		}
		
		/** on complete */
		private function onComplete(event:Event):void
		{
			log("--- on complete");
			if (_loader.bytesLoaded < _loader.bytesTotal) return;
			
			var lc:LoaderContext = new LoaderContext();
			lc.checkPolicyFile = false;
			lc.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			
			_contentLoader = new Loader();
			_contentLoader.contentLoaderInfo.addEventListener(Event.INIT, onContentInit);
			_contentLoader.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onContentUncaughtError);
			_contentLoader.loadBytes(_loader.data, lc);
		}
		
		/**
		 * on centent uncaught error
		 */
		private function onContentUncaughtError(event:Event):void
		{
			log("--- on content uncaught error");
			dispatchEvent(event);
		}
		
		/**
		 * on content init
		 */
		private function onContentInit(event:Event):void
		{
			log("--- on content init");
			
			event.stopImmediatePropagation();
			
			var content:DisplayObject = _contentLoader.content;
			var className:String = getQualifiedSuperclassName(content);
			var isFlexApp:Boolean = className == "mx.managers::SystemManager";
			log("is flex application: " + isFlexApp);
			if (isFlexApp)
			{
				var info:Object = content["info"]();
			}
			
			// unload content loader
			_contentLoader.unloadAndStop();
			_contentLoader = null;
			
			// 不是systemmanager，直接完成
			if (!info)
			{
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			_requests = [];
			try {
				var rsls:Array = info.cdRsls as Array;
				if (rsls && rsls.length)
				{
					for (var i:int = 0; i < rsls.length; i++)
					{
						var singleRsl:Array = rsls[i] as Array;
						if (singleRsl && singleRsl.length)
						{
							for (var j:int = 0; j < singleRsl.length; j++)
							{
								var rslData:Object = singleRsl[j];
								if (!rslData) continue;
								// 暂时只处理swz
								if (!rslData.isSigned) continue;
								var req:URLRequest = new URLRequest();
								req.url = rslData.rslURL;
								req.digest = rslData.digest;
								_requests.push(req);
								// 第一个成功的话就跳过备用地址
								break;
							}
						}
					}
				}
			}
			catch(err:Error) {
				// TODO 错误的话，怎么处理？
			}
			
			loadRsls();
		}
		
		
		/**
		 * load rsls
		 */
		private function loadRsls():void
		{
			log("begin loading rsls, length=" + _requests.length);
			
			var regex:RegExp = /(\/[^\/]+?)\.sw(?:f|z)$/;
			for (var i:int = 0; i < _requests.length; i++)
			{
				var req:URLRequest = _requests[i];
				if (_rslRoot)
				{
					var url:String = req.url;
					var arr:Array = url.match(regex);
					if (arr && arr.length>1)
					{
						url = _rslRoot + "/" + arr[1] + ".swz";
						url = URLUtil.trim(url);
						log("trans rsl url, from("+req.url+") to ("+url+")");
						req.url = url;
					}
				}
			}
			
			loadNextRsl();
		}
		
		/**
		 * load next rsl
		 */
		private function loadNextRsl():void
		{
			if (!_requests.length)
			{
				log("rsls loading complete");
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			var req:URLRequest = _requests.shift();
			log("load rsl: " + req.url + "("+_requests.length+" left)");
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onRslIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRslSecurityError);
			loader.addEventListener(Event.COMPLETE, onRslComplete);
			loader.load(req);
		}
		
		private function onRslIOError(event:IOErrorEvent):void
		{
			log("--- on rsl io error");
			_requests = [];
			dispatchEvent(event);
		}
		
		private function onRslSecurityError(event:SecurityErrorEvent):void
		{
			log("--- on rsl security error");
			_requests = [];
			dispatchEvent(event);
		}
		
		private function onRslComplete(event:Event):void
		{
			log("--- on rsl complete");
			var loader:URLLoader = URLLoader(event.currentTarget);
			if (loader.bytesLoaded < loader.bytesTotal) return;
			
			loadNextRsl();
		}
		
		
		private function log(msg:String):void
		{
			_logger.debug("[VoxFlexLoader] " + msg);
		}
		
		public function get data():*
		{
			return _loader ? _loader.data : null;
		}
		
	}
}