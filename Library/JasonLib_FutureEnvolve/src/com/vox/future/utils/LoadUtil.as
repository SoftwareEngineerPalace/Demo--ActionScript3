package com.vox.future.utils
{
	import com.vox.gospel.utils.URLUtil;
	import com.vox.gospel.utils.VersionUtil;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	/**
	 * 功能: 加载工具类，会自动重试3次，并且每次自动替换时间戳
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class LoadUtil
	{
		private static const _DEFAULT_TIMEOUT_TIME:int = 20000;
		
		// 2015.2.4 派发个事件
		public static var dispatcher:EventDispatcher = new EventDispatcher () ;
		
		CONFIG::DEVs
		{
			throw new Error("该类已不维护，请改用Gospel中的LoadUtil");
		}
		
		/**
		 * 使用Loader加载，加载完成后会把Loader传递给onComplete方法
		 * @param url 加载地址
		 * @param onComplete 成功回调，参数是Loader对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param onProgress 进度汇报回调，参数是ProgressEvent对象
		 * @param context 加载器上下文
		 * @param version 加载时添加在URL中的版本字符串，null表示不使用
		 * @param timeoutTime 超时时间（default=20s）
		 * @param flashvars 传给加载对象的参数 会传入
		 */		
		public static function loaderLoad(url:String, onComplete:Function=null, onError:Function=null, onProgress:Function=null, context:LoaderContext=null, version:String=null, timeoutTime:int=-1 , flashvars:Object = null):void
		{
			var loader:Loader = new Loader();
			var retryCount:int = 2;
			
			if (timeoutTime<=0) timeoutTime = _DEFAULT_TIMEOUT_TIME;
			var progressTimer:Timer = new Timer(500, 0);
			startTimer();
			
			addListeners();
			if(context == null) context = new LoaderContext();
			if(Security.sandboxType == Security.REMOTE)
			{
				context.securityDomain = SecurityDomain.currentDomain;
			}
			else
			{
				context.securityDomain = null;
			}
			if(version == null) version = VersionUtil.COMPILE_VERSION;
			if(version != null) url = com.vox.gospel.utils.URLUtil.appendParams(url, {v:version});
			var req:URLRequest = new URLRequest(url);
			loader.load(req, context);
			
			function addListeners():void
			{
				if(loader != null)
				{
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
					loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
				}
			}
			
			function removeListeners():void
			{
				if(loader != null)
				{
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
					loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
				}
				stopTimer();
			}
			
			function onLoadComplete(event:Event):void
			{
				if(loader.contentLoaderInfo.bytesLoaded < loader.contentLoaderInfo.bytesTotal)
				{
					// 实际上没加载成功，有可能是IE缓存了错误的数据导致的
					onLoadIOError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "缓存了错误的数据。"));
				}
				else
				{
					// 加载成功了
					if(onComplete != null) onComplete(loader);
					removeListeners();
					loader = null;
				}
			}
			
			function onLoadIOError(event:IOErrorEvent):void
			{
				if(retryCount > 0)
				{
					// 重试次数还没到，加一个时间戳继续重试
					retryCount --;
					startTimer();
					var retryURL:String = com.vox.gospel.utils.URLUtil.appendParams(url, {n:new Date().time});
					try {loader.close();} catch(error:Error) {}
					loader.unloadAndStop();
					loader.load(new URLRequest(retryURL), context);
				}
				else
				{
					// 重试次数到了，调用失败回调
					if(onError != null) onError(event);
					removeListeners();
					try {loader.close();} catch(error:Error) {}
					loader.unloadAndStop();
					loader = null;
				}
			}
			
			function onLoadProgress(event:ProgressEvent):void
			{
				if(onProgress != null) onProgress(event);
			}
			
			function onLoadSecurityError(event:SecurityErrorEvent):void
			{
				// 沙箱错误，不需要重试，直接调用失败回调
				if(onError != null) onError(event);
				removeListeners();
				try {loader.close();} catch(error:Error) {}
				loader.unloadAndStop();
				loader = null;
			}
			
			function startTimer():void
			{
				stopTimer();
				progressTimer.addEventListener(TimerEvent.TIMER, onProgressTimer);
				progressTimer.start();
				lastProgress = 0;
				lastProgressTime = getTimer();
			}
			
			function stopTimer():void
			{
				progressTimer.removeEventListener(TimerEvent.TIMER, onProgressTimer);
				progressTimer.stop();
			}
			
			var lastProgress:uint;
			var lastProgressTime:uint;
			
			function onProgressTimer(event:Event):void
			{
				var progress:uint = loader.contentLoaderInfo.bytesLoaded;
				var time:uint = getTimer();
				if (progress > lastProgress)
				{
					lastProgress = progress;
					lastProgressTime = time;
					return;
				}
				
				if (time - lastProgressTime > timeoutTime)
				{
					onLoadIOError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "zero speed timeout"));
					// 如果超过了时限，则停止加载流程，防止多次报错
					removeListeners();
					try {loader.close();} catch(error:Error) {}
					loader.unloadAndStop();
					loader = null;
				}
			}
			
		}
		
		/**
		 * 绕过安全沙箱检查使用Loader进行加载，加载完成后会把Loader传递给onComplete方法
		 * @param url 加载地址
		 * @param onComplete 成功回调，参数是Loader对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param onProgress 进度汇报回调，参数是ProgressEvent对象
		 * @param context 加载器上下文
		 * @param version 加载时添加在URL中的版本字符串，null表示不使用
		 * @param timeoutTime 超时时间（default=20s）
		 */		
		public static function loaderLoadWithoutSandbox(url:String, onComplete:Function=null, onError:Function=null, onProgress:Function=null, context:LoaderContext=null, version:String=null, timeoutTime:int=-1):void
		{
			// 首先使用URLLoader加载ByteArray
			LoadUtil.urlLoaderLoad(url, function(bytes:ByteArray):void
			{
				// 然后使用Loader.loadBytes加载
				LoadUtil.loaderLoadBytes(bytes, onComplete, onError, function(event:ProgressEvent):void
				{
					// 这步加载是后面的20%
					var newEvent:ProgressEvent = new ProgressEvent(event.type, event.bubbles, event.cancelable, event.bytesTotal + event.bytesLoaded * 0.25, event.bytesTotal * 1.25);
					if(onProgress != null) onProgress(newEvent);
				}, context);
			}, onError, function(event:ProgressEvent):void
			{
				// 这步加载只能算前80%，后面20%留给loadBytes
				var newEvent:ProgressEvent = new ProgressEvent(event.type, event.bubbles, event.cancelable, event.bytesLoaded, event.bytesTotal * 1.25);
				if(onProgress != null) onProgress(newEvent);
			}, URLLoaderDataFormat.BINARY, version, timeoutTime);
		}
		
		/**
		 * 使用Loader加载ByteArray，加载完成后会把Loader传递给onComplete方法
		 * @param bytes 要被加载的ByteArray对象
		 * @param onComplete 成功回调，参数是Loader对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param onProgress 进度汇报回调，参数是ProgressEvent对象
		 * @param context 加载器上下文
		 */		
		public static function loaderLoadBytes(bytes:ByteArray, onComplete:Function=null, onError:Function=null, onProgress:Function=null, context:LoaderContext=null):void
		{
			var loader:Loader = new Loader();
			addListeners();
			if(context == null) context = new LoaderContext();
			// 因为loadBytes是不允许使用SecurityDomain的，所以这里暂时把它设置为null，加载操作完成后再赋值回来
			var securityDomain:SecurityDomain = context.securityDomain;
			context.securityDomain = null;
			// 开始加载
			loader.loadBytes(bytes, context);
			context.securityDomain = securityDomain;
			
			function addListeners():void
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
			}
			
			function removeListeners():void
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
			}
			
			function onLoadComplete(event:Event):void
			{
				if(loader.contentLoaderInfo.bytesLoaded < loader.contentLoaderInfo.bytesTotal)
				{
					// 实际上没加载成功，有可能是IE缓存了错误的数据导致的
					onLoadIOError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "缓存了错误的数据。"));
				}
				else
				{
					// 加载成功了
					if(onComplete != null) onComplete(loader);
					removeListeners();
					loader = null;
				}
			}
			
			function onLoadIOError(event:IOErrorEvent):void
			{
				if(onError != null) onError(event);
				removeListeners();
				try {loader.close();} catch(error:Error) {}
				loader.unloadAndStop();
				loader = null;
			}
			
			function onLoadProgress(event:ProgressEvent):void
			{
				if(onProgress != null) onProgress(event);
			}
			
			function onLoadSecurityError(event:SecurityErrorEvent):void
			{
				// 沙箱错误，不需要重试，直接调用失败回调
				if(onError != null) onError(event);
				removeListeners();
				try {loader.close();} catch(error:Error) {}
				loader.unloadAndStop();
				loader = null;
			}
		}
		
		/**
		 * 使用URLLoader加载，加载完成后会把data传递给onComplete方法
		 * @param url 加载地址
		 * @param onComplete 成功回调，参数是加载后的content对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param onProgress 进度汇报回调，参数是ProgressEvent对象
		 * @param dataFormat URLLoaderDataFormat内的常量值，默认值是URLLoaderDataFormat.TEXT
		 * @param version 加载时添加在URL中的版本字符串，null表示不使用
		 * @param timeoutTime 超时时间（default=20s）
		 */		
		public static function urlLoaderLoad(url:String, onComplete:Function=null, onError:Function=null, onProgress:Function=null, dataFormat:String=null, version:String=null, timeoutTime:int=-1 , method:String = null):void
		{
			var loader:URLLoader = new URLLoader();
			var retryCount:int = 2;
			
			if (timeoutTime<=0) timeoutTime = _DEFAULT_TIMEOUT_TIME;
			var progressTimer:Timer = new Timer(500, 0);
			startTimer();
			
			addListeners();
			if(dataFormat == null) dataFormat = URLLoaderDataFormat.TEXT;
			loader.dataFormat = dataFormat;
			if(version == null) version = VersionUtil.COMPILE_VERSION;
			if(version != null) url = com.vox.gospel.utils.URLUtil.appendParams(url, {v:version});
			var urlRequest:URLRequest = new URLRequest(url);
			if(method == null)urlRequest.method = URLRequestMethod.POST;
			loader.load(urlRequest);
			
			function addListeners():void
			{
				if(loader != null)
				{
					loader.addEventListener(Event.COMPLETE, onLoadComplete);
					loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
					loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				}
			}
			
			function removeListeners():void
			{
				if(loader != null)
				{
					loader.removeEventListener(Event.COMPLETE, onLoadComplete);
					loader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
					loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
					loader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				}
				stopTimer();
			}
			
			function onLoadComplete(event:Event):void
			{
				if(loader.bytesLoaded < loader.bytesTotal)
				{
					// 实际上没加载成功，有可能是IE缓存了错误的数据导致的
					onLoadIOError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "缓存了错误的数据。"));
				}
				else
				{
					// 加载成功了
					if(onComplete != null) onComplete(loader.data);
					removeListeners();
					try {loader.close();} catch(error:Error) {}
					loader = null;
				}
			}
			
			function onLoadIOError(event:IOErrorEvent):void
			{
				if(retryCount > 0)
				{
					// 重试次数还没到，加一个时间戳继续重试
					retryCount --;
					startTimer();
					var retryURL:String = com.vox.gospel.utils.URLUtil.appendParams(url, {n:new Date().time});
					try {loader.close();} catch(error:Error) {}
					loader.load(new URLRequest(retryURL));
				}
				else
				{
					// 重试次数到了，调用失败回调
					if(onError != null) onError(event);
					removeListeners();
					try {loader.close();} catch(error:Error) {}
					loader = null;
				}
			}
			
			function onLoadSecurityError(event:SecurityErrorEvent):void
			{
				// 沙箱错误，不需要重试，直接调用失败回调
				if(onError != null) onError(event);
				removeListeners();
				try {loader.close();} catch(error:Error) {}
				loader = null;
			}
			
			function onLoadProgress(event:ProgressEvent):void
			{
				if(onProgress != null) onProgress(event);
			}
			
			function startTimer():void
			{
				stopTimer();
				progressTimer.addEventListener(TimerEvent.TIMER, onProgressTimer);
				progressTimer.start();
				lastProgress = 0;
				lastProgressTime = getTimer();
			}
			
			function stopTimer():void
			{
				progressTimer.removeEventListener(TimerEvent.TIMER, onProgressTimer);
				progressTimer.stop();
			}
			
			var lastProgress:uint;
			var lastProgressTime:uint;
			
			function onProgressTimer(event:Event):void
			{
				var progress:uint = loader.bytesLoaded;
				var time:uint = getTimer();
				if (progress > lastProgress)
				{
					lastProgress = progress;
					lastProgressTime = time;
					return;
				}
				
				if (time - lastProgressTime > timeoutTime)
				{
					onLoadIOError(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "zero speed timeout"));
					// 如果超过了时限，则停止加载流程，防止多次报错
					removeListeners();
					try {loader.close();} catch(error:Error) {}
					loader = null;
				}
			}
		}
	}
}