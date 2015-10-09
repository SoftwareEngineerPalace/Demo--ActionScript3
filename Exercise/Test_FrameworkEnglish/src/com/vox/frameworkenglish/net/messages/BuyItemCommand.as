package com.vox.frameworkenglish.net.messages
{
	import com.vox.future.request.BaseMessageType;
	import com.vox.future.request.BaseRequestCommand;
	
	import flash.events.IEventDispatcher;

	public class BuyItemCommand extends BaseRequestCommand
	{
		[Inject]
		public var dipatcher:IEventDispatcher ;
		
		public function BuyItemCommand()
		{
		}
		
		override public function execute():void
		{
			var msg
		}
		
		override public function onResponse(result:Object):void
		{
			super.onResponse(result);
		}
		
		override public function onResponseError():void
		{
			super.onResponseError();
		}
		
		override protected function packMessage():Object
		{
			return super.packMessage();
		}
		
		override protected function parseResponse(result:Object):BaseMessageType
		{
			return super.parseResponse(result);
		}
		
		
		
	}
}