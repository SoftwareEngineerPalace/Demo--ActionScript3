package com.vox.future.utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	/** * @author guang.yang 
	 * @E-mail: blasttnt@163.com 
	 * @version 1.0.0 
	 * @Date：Jul 7, 2014 2:15:00 PM * 
	 */
	
	public class SoundUtil
	{
		public function SoundUtil()
		{
		}
		
		/**
		 * 使用Sound加载，加载完成后会把Sound传递给onComplete方法
		 * @param url 加载地址
		 * @param retryCount 重试次数，默认为1，不重试
		 * @param onComplete 成功回调，参数是Sound对象
		 * @param onError 错误回调，参数是ErrorEvent对象
		 * @param context 加载器上下文
		 */
		public static function loadSound(url:String, retryCount:int=1, onComplete:Function=null, onError:Function=null, soundLoaderContext:SoundLoaderContext=null):void
		{
			var sound:Sound = new Sound();
			mapListeners();
			if(soundLoaderContext == null) soundLoaderContext = new SoundLoaderContext();
			if(url && url != "")
				sound.load(new URLRequest(url), soundLoaderContext);
			
			function mapListeners():void
			{
				sound.addEventListener(Event.COMPLETE, onLoadComplete);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
				sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
			}
			
			function unmapListeners():void
			{
				sound.removeEventListener(Event.COMPLETE, onLoadComplete);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadIOError);
				sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadSecurityError);
			}
			
			function onLoadComplete(event:Event):void
			{
				if(onComplete != null) onComplete(sound);
				sound = null;
				unmapListeners();
			}
			
			function onLoadIOError(event:IOErrorEvent):void
			{
				if(retryCount > 0)
				{
					// 重试次数还没到，加一个时间戳继续重试
					retryCount --;
					var retryURL:String = URLUtil.joinParams(url, {n:new Date().time});
					sound.load(new URLRequest(retryURL), soundLoaderContext);
				}
				else
				{
					// 重试次数到了，调用失败回调
					if(onError != null) onError(event);
					unmapListeners();
					sound.close();
					sound = null;
				}
			}
			
			function onLoadSecurityError(event:SecurityErrorEvent):void
			{
				// 沙箱错误，不需要重试，直接调用失败回调
				if(onError != null) onError(event);
				unmapListeners();
				sound.close();
				sound = null;
			}
		}
	}
}