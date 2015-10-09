package com.vox.gospel.events
{
	
	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class CommonAsyncOverEvent extends CommonEvent implements IAsyncOverEvent
	{
		private var _isComplete:Boolean;
		
		public function isComplete():Boolean
		{
			return _isComplete;
		}
		
		public function CommonAsyncOverEvent(type:String, isComplete:Boolean, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_isComplete = isComplete;
			super(type, bubbles, cancelable, data);
		}
	}
}