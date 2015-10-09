package com.vox.future.commands
{
	import flash.utils.Dictionary;
	
	import org.robotlegs.events.ContextEventDispatchEvent;
	import org.robotlegs.mvcs.Command;
	
	public class ContextEventDispatchCommand extends Command
	{
		[Inject]
		public var event:ContextEventDispatchEvent ;
		[Inject(name="MessageHandlerDict")]
		public var messageHandlerDict:Dictionary ;
		
		public function ContextEventDispatchCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			// TODO Auto Generated method stub
			super.execute();
		}
		
		
	}
}