package com.vox.app.framework
{
	/**
	 * 应用框架的上下文接口，使用该接口进行注入操作，可以一定程度上与框架进行交互
	 * @author jishu
	 */
	public interface IAppFrameContext
	{
		function get usable():Boolean ;
		function get userId():String ;
		function get userName():String ;
		function get currency():int ;
		
		function createPositiveWithBG():IAppFrameRole ;
		function createPositive():IAppFrameRole ;
		function createProfile():IAppFrameRole ;
	}
}