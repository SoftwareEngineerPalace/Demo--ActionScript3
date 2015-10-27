package com.vox.utils
{
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
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
		
		/**
		 * 使用Loader加载，加载完成后会把Loader传递给onComplete方法
		 * @param url 加载地址
		 * @param onComplete 成功回调，参数是Loader对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param onProgress 进度汇报回调，参数是ProgressEvent对象
		 * @param context 加载器上下文
		 * @param version 加载时添加在URL中的版本字符串，null表示不使用
		 * @param timeoutTime 超时时间（default=20s）
		 * @param method 加载方法，默认为POST，在URLRequestMethod中查找常量
		 * @return 加载控制器
		 */		
		public static function loaderLoad(url:String, onComplete:Function=null, onError:Function=null, onProgress:Function=null, context:LoaderContext=null, version:String=null, timeoutTime:int=-1, method:String="POST"):ILoadUtilHandler
		{
			var loader:Loader = new Loader();
			var handler:LoaderHandler = new LoaderHandler(loader);
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
			if(version != VersionUtil.VERSION_NONE)
			{
				if(version == null) version = VersionUtil.COMPILE_VERSION;
				if(version != null) url = com.vox.gospel.utils.URLUtil.appendParams(url, {v:version});
			}
			var req:URLRequest = new URLRequest(url);
			req.method = method;
			loader.load(req, context);
			// 返回控制器
			return handler;
			
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
					// 重试次数到了，尝试切换CDN
					PathUtil.changeImgDomain(function(imgDomain:String):void
					{
						if(imgDomain != null)
						{
							// 切换CDN成功，重试加载
							// 加一个2秒延迟，防止无限循环对服务器造成压力
							setTimeout(function():void
							{
								retryCount = 2;
								startTimer();
								try {loader.close();} catch(error:Error) {}
								loader.unloadAndStop();
								loader.load(new URLRequest(url), context);
							}, 2000);
						}
						else
						{
							// 调用失败回调
							if(onError != null) onError(event);
							removeListeners();
							try {loader.close();} catch(error:Error) {}
							loader.unloadAndStop();
							loader = null;
						}
					});
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
		 * @return 加载控制器
		 */		
		public static function loaderLoadWithoutSandbox(url:String, onComplete:Function=null, onError:Function=null, onProgress:Function=null, context:LoaderContext=null, version:String=null, timeoutTime:int=-1):ILoadUtilHandler
		{
			var handler:MacroHandler = new MacroHandler();
			// 首先使用URLLoader加载ByteArray
			handler.handler = LoadUtil.urlLoaderLoad(url, function(bytes:ByteArray):void
			{
				// 然后使用Loader.loadBytes加载
				handler.handler = LoadUtil.loaderLoadBytes(bytes, onComplete, onError, function(event:ProgressEvent):void
				{
					// 这步加载是后面的20%
					var newEvent:ProgressEvent = new ProgressEvent(event.type, event.bubbles, event.cancelable, event.bytesTotal + event.bytesLoaded * 0.25, event.bytesTotal * 1.25);
					if(onProgress != null) onProgress(newEvent);
				}, context);
			}, function(event:ErrorEvent):void
			{
				if(event is IOErrorEvent)
				{
					// 尝试切换CDN
					PathUtil.changeImgDomain(function(imgDomain:String):void
					{
						if(imgDomain != null)
						{
							// 切换CDN成功，重试加载
							// 加一个2秒延迟，防止无限循环对服务器造成压力
							setTimeout(function():void
							{
								handler.handler = LoadUtil.loaderLoadWithoutSandbox(url, onComplete, onError, onProgress, context, version, timeoutTime);
							}, 2000);
						}
						else
						{
							// 调用失败回调
							if(onError != null) onError(event);
						}
					});
				}
				else
				{
					if(onError != null) onError(event);
				}
			}, function(event:ProgressEvent):void
			{
				// 这步加载只能算前80%，后面20%留给loadBytes
				var newEvent:ProgressEvent = new ProgressEvent(event.type, event.bubbles, event.cancelable, event.bytesLoaded, event.bytesTotal * 1.25);
				if(onProgress != null) onProgress(newEvent);
			}, URLLoaderDataFormat.BINARY, version, timeoutTime);
			// 返回控制器
			return handler;
		}
		
		/**
		 * 使用Loader加载ByteArray，加载完成后会把Loader传递给onComplete方法
		 * @param bytes 要被加载的ByteArray对象
		 * @param onComplete 成功回调，参数是Loader对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param onProgress 进度汇报回调，参数是ProgressEvent对象
		 * @param context 加载器上下文
		 * @return 加载控制器
		 */		
		public static function loaderLoadBytes(bytes:ByteArray, onComplete:Function=null, onError:Function=null, onProgress:Function=null, context:LoaderContext=null):ILoadUtilHandler
		{
			var loader:Loader = new Loader();
			var handler:LoaderHandler = new LoaderHandler(loader);
			addListeners();
			if(context == null) context = new LoaderContext();
			// 因为loadBytes是不允许使用SecurityDomain的，所以这里暂时把它设置为null，加载操作完成后再赋值回来
			var securityDomain:SecurityDomain = context.securityDomain;
			context.securityDomain = null;
			// 开始加载
			loader.loadBytes(bytes, context);
			context.securityDomain = securityDomain;
			// 返回控制器
			return handler;
			
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
		 * @param method 加载方法，默认为GET，在URLRequestMethod中查找常量
		 * @param data 要提交的数据
		 * @return 加载控制器
		 */		
		public static function urlLoaderLoad(url:String, onComplete:Function=null, onError:Function=null, onProgress:Function=null, dataFormat:String=null, version:String=null, timeoutTime:int=-1, method:String="GET", data:Object=null):ILoadUtilHandler
		{
			var loader:URLLoader = new URLLoader();
			var handler:URLLoaderHandler = new URLLoaderHandler(loader);
			var retryCount:int = 2;
			
			if (timeoutTime<=0) timeoutTime = _DEFAULT_TIMEOUT_TIME;
			var progressTimer:Timer = new Timer(500, 0);
			startTimer();
			
			addListeners();
			if(dataFormat == null) dataFormat = URLLoaderDataFormat.TEXT;
			loader.dataFormat = dataFormat;
			// 组织数据
			var hasData:Boolean = false;
			if(!(data is URLVariables))
			{
				var tempData:Object = data;
				data = new URLVariables();
				for(var key:String in tempData)
				{
					data[key] = tempData[key];
					hasData = true;
				}
			}
			else
			{
				// 如果数据是URLVariables，自动认为有数据
				hasData = true;
			}
			if(version != VersionUtil.VERSION_NONE)
			{
				if(version == null) version = VersionUtil.COMPILE_VERSION;
				if(version != null)
				{
					if(method == URLRequestMethod.GET)
					{
						data.v = version;
						hasData = true;
					}
					else
					{
						url = com.vox.gospel.utils.URLUtil.appendParams(url, {v:version});
					}
				}
			}
			var request:URLRequest = new URLRequest(url);
			request.method = method;
			request.data = (hasData ? data : null);
			loader.load(request);
			// 返回控制器
			return handler;
			
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
				if(Capabilities.playerType=="ActiveX"&&loader.bytesLoaded < loader.bytesTotal)
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
					
					var request:URLRequest = new URLRequest(retryURL);
					request.method = method;
					request.data = (hasData ? data : null);
					loader.load(request);
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


import com.vox.gospel.utils.ILoadUtilHandler;

import flash.display.Loader;

class LoaderHandler implements ILoadUtilHandler
{
	private var _loader:Loader;
	
	public function LoaderHandler(loader:Loader)
	{
		_loader = loader;
	}
	
	public function clearLoad():void
	{
		if(_loader != null)
		{
			try
			{
				_loader.close();
			} 
			catch(error:Error) 
			{
			}
			_loader.unload();
			_loader = null;
		}
	}
}


import com.vox.gospel.utils.ILoadUtilHandler;

import flash.net.URLLoader;

class URLLoaderHandler implements ILoadUtilHandler
{
	private var _loader:URLLoader;
	
	public function URLLoaderHandler(loader:URLLoader)
	{
		_loader = loader;
	}
	
	public function clearLoad():void
	{
		if(_loader != null)
		{
			try
			{
				_loader.close();
			} 
			catch(error:Error) 
			{
			}
			_loader = null;
		}
	}
}


class MacroHandler implements ILoadUtilHandler
{
	private var _handler:ILoadUtilHandler;
	
	/** 设置子控制器 */
	public function set handler(value:ILoadUtilHandler):void
	{
		_handler = value;
	}
	
	public function MacroHandler()
	{
	}
	
	public function clearLoad():void
	{
		if(_handler != null)
		{
			_handler.clearLoad();
			_handler = null;
		}
	}
}