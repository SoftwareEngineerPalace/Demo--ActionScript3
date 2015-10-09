package com.vox.game.load
{
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;

	/**
	 * 小游戏加载代码响应接口
	 * @author jishu
	 */
	public interface ILoadProxyHandler
	{
		function onLoadStart():void;
		function onLoadComplete( $game:DisplayObject ):void;
		function onLoadError( $evt:ErrorEvent ):void ;
		function onLoadProgress( $url:String, $curIndex:uint, $totalNum:int, $numBytes:Number, $totalBytes:Number ):void ;
		function onGameEnd():void ;
		
	}
}