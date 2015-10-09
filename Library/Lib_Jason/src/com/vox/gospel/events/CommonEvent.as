package com.vox.gospel.events
{
	import flash.events.Event;
	
	/**
	 * 功能: 通用事件，在事件中包装了一个万能data对象
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class CommonEvent extends Event
	{
		public var data:*;
		
		public function CommonEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new CommonEvent(type, bubbles, cancelable, data);
		}
	}
}