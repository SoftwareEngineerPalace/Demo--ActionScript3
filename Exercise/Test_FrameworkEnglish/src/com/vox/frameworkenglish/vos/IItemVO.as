package com.vox.frameworkenglish.vos
{
	/**
	 * 物品的接口 
	 */
	public interface IItemVO
	{
		function get id():String ;
		function get name():String ;
		function get image():* ;
		function get price():uint ;
		function get earned():Boolean ;
		function get equiped():Boolean ;
	}
}