package com.vox.app.framework
{
	import flash.display.Sprite;
	
	import mx.states.AddChild;

	public class AppFrameRoleAdapter extends Sprite implements IAppFrameRole 
	{
		private var _target:*; 
		public function AppFrameRoleAdapter( $target:* )
		{
			_target = $target ;
			AddChild( _target ) ;
		}
		
		public function attack($cbk:Function=null):void
		{
			_target.attack($cbk);
		}
		
		public function cheer():void
		{
			_target.cheer();
		}
		
		public function hurt($cbk:Function=null):void
		{
			_target.hurt( $cbk ) ;
		}
		
		public function idle():void
		{
			_target.idle();
		}
		
		public function run($cbk:Function=null, $x:Number=NaN, $y:Number=NaN, $speed:Number=0, $reset:Boolean=true):void
		{
			_target.run( $cbk, $x, $y, $speed, $reset ) ;
		}
		
		public function sorrow():void
		{
			_target.sorrow();
		}
		
		
	}
}