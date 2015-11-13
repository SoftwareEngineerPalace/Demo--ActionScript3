package com.vox.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.system.LoaderContext;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 
	 * @author jishu
	 */
	public class LoadUtil
	{
		
		//----------------------------------------attrs 0 const--------------------------------------------------//
		private static const Default_Timeout_Duration          :uint = 20 * 1000 ;
		private static const Default_Progress_TimerDelay       :uint = 500 ;
		//----------------------------------------attrs 1 ui-----------------------------------------------------//
		
		//----------------------------------------attrs 2 status-------------------------------------------------//
		
		//----------------------------------------attrs 3 data---------------------------------------------------//
		
		//----------------------------------------attrs 4 model--------------------------------------------------//
		
		//----------------------------------------attrs 5 getter setter------------------------------------------//
		
		
		//----------------------------------------funs 0 API-----------------------------------------------------//
		/**
		 * 通过　Loader 来加载
		 * @param $url
		 * @param $onComplete
		 * @param $onError
		 * @param $onProgress
		 * @param $context
		 * @param $version
		 * @param $timeoutTime
		 * @param $method
		 */
		public static function loadByLoader( $url:String, $onComplete:Function=null, 
											 $onError:Function=null, $onProgress:Function=null, 
											 $context:LoaderContext=null, $version:String=null, 
											 $timeoutTime:int = -1, $method:String="POST" ):void
		{
			var __loader:Loader = new Loader( ) ;
			var __handler:Loaderhandler = new Loaderhandler( __loader ) ;
			var __retryCount:int = 2 ;
			if( $timeoutTime <= 0 ) $timeoutTime = Default_Timeout_Duration ;
			var __progressTimer:Timer = new Timer( Default_Progress_TimerDelay, 0 ) ;
			
			function startProgressTimer():void
			{
				
			}
			
			function stopProgressTimer():void
			{
				__progressTimer.removeEventListener(TimerEvent.TIMER, onProgressTimer ) ;
				__progressTimer.stop() ;
			}
			
			var lastProgress:uint ;
			var lastProgressTime:uint ;
			function onProgressTimer( $evt:TimerEvent ):void
			{
				var curProgress:uint = __loader.contentLoaderInfo.bytesLoaded ;
				var time:Number = getTimer() ;
				if( curProgress > lastProgress ) //如果当前有进度，则要记录下来
				{
					lastProgress = curProgress ;
					lastProgressTime = time ;
					return ;
				}
				if( time - lastProgressTime > $timeoutTime ) //如果本次进度与上次进度时差 大于 timeout时长
				{
					
				}
			}
			
			function onLoadIOError( $evt:IOErrorEvent ):void
			{
				if( __retryCount > 0 )//重试次数还没到，加一个时间戳继续重试
				{
					__retryCount -- ; 
					startProgressTimer() ;
				}
			}
		}
		//----------------------------------------funs 1 init-----------------------------------------------------//
		
		
		
		//----------------------------------------funs 2 process-------------------------------------------------//
		
		
		
		//----------------------------------------funs 3 listener------------------------------------------------//
		
		
		
		//----------------------------------------funs 4 tool ---------------------------------------------------//
	
		
		
		//----------------------------------------funs 5 dispose-------------------------------------------------//



	}
}


import com.vox.utils.interfaces.ILoadUtilHandler;

import flash.display.Loader;

class Loaderhandler implements ILoadUtilHandler
{
	private var _loader:Loader;
	
	public function Loaderhandler( $loader:Loader )
	{
		_loader = $loader ;
	}
	
	public function clearLoad():void
	{
		if( _loader != null )
		{
			try
			{
				_loader.close() ;
			} 
			catch(error:Error) 
			{
				
			}
			finally
			{
				_loader.unload() ;
				_loader = null ;
			}
		}
	}
}

class MacroHandler implements ILoadUtilHandler
{
	public function MacroHandler()
	{
	}
	
	private var _handler:ILoadUtilHandler;
	
	public function set handler( $value:ILoadUtilHandler ):void
	{
		_handler = $value ;
	}
	
	public function clearLoad():void
	{
		if( _handler != null )
		{
			_handler.clearLoad( ) ;
			_handler = null ;
		}
	}
}