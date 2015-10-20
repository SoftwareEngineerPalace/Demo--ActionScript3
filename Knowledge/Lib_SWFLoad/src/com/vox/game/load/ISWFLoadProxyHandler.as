package com.vox.game.load
{
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;

	/**
	 * swf文件加载代理响应接口
	 * @author 肖建军
	 */
	public interface ISWFLoadProxyHandler
	{
		/**
		 * 加载开始时调用
		 */
		function onLoadStart():void;
		
		/**
		 * 加载完毕调用
		 * @param $game
		 */
		function onLoadComplete( $game:DisplayObject ) :void;
		
		/**
		 * 加载出错时调用
		 * @param $evt
		 */
		function onLoadError( $evt:ErrorEvent ):void ;
		
		/**
		 * 游戏结束调用 
		 * @param $result 结果数据
		 */
		function onGameEnd( $result:Object ):void;
		
		/**
		 * @param $url 要加载的文件的 url
		 * @param $curIndex 当前加载文件的索引
		 * @param $totalNum 加载文件的总数量
		 * @param $numBytes 当前加载文件已加载字节数
		 * @param $totalBytes 当前加载文件总字节数
		 */
		function onLoadProgress( $url:String, $curIndex:int, $totalNum:uint, $numBytes:Number, $totalBytes:Number ):void;
		
	}
}