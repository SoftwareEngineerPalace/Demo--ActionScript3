package com.vox.app.framework
{
	/**
	 * 应用框架上下文适配器，必须使用这个适配器才能在两个ApplicationDomain中使用同名类.
	 * @author jishu
	 */
	public class AppFrameContextAdapter implements IAppFrameContext 
	{
		private var _target:* ;
		public function AppFrameContextAdapter( $target:* )
		{
			_target = $target ;
		}
		
		public function createPositive():IAppFrameRole
		{
			return new AppFrameRoleAdapter( _target.createPositive ) ;
		}
		
		public function createPositiveWithBG():IAppFrameRole
		{
			return new AppFrameRoleAdapter( _target.createPositiveWithBG ) ;
		}
		
		public function createProfile():IAppFrameRole
		{
			return new AppFrameRoleAdapter( _target.createProfile ) ;
		}
		
		public function get currency():int
		{
			return _target.currency ;
		}
		
		public function get usable():Boolean
		{
			return _target.usable 
		}
		
		public function get userId():String
		{
			return _target.userId ;
		}
		
		public function get userName():String
		{
			return _target.usrName ;
		}
		
		
	}
}