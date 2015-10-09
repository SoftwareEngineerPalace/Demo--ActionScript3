package com.vox.app.framework
{
	public interface IAppFrameRole
	{
		function idle():void ;
		function cheer():void ;
		function sorrow():void;
		
		function attack( $cbk:Function = null ):void ;
		function hurt( $cbk:Function = null ):void ;
		function run( $cbk:Function = null, $x:Number=NaN, $y:Number=NaN, $speed:Number=0, $reset:Boolean=true):void ;
	}
}