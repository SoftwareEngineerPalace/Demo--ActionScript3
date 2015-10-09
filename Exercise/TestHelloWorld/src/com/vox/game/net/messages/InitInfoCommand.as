package com.vox.game.net.messages
{
	import com.vox.future.notifications.events.GetServerResponseEvent;
	import com.vox.future.request.BaseMessageType;
	import com.vox.future.request.BaseRequestCommand;
	import com.vox.future.request.BaseRequestMessage;
	import com.vox.game.net.types.*;
	import com.vox.game.net.types.response.*;
	import com.vox.game.net.types.response.InitInfoResponse;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * 推题
	 */
	public class InitInfoCommand extends BaseRequestCommand
	{
		[Inject]
		public var dispatcher:IEventDispatcher;
		
		public function InitInfoCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			var msg:InitInfoMessage = BaseRequestMessage.requestMSG as InitInfoMessage;
			this.msg = msg;
			msg._data = "data=" + encodeURIComponent(JSON.stringify(this.packMessage()));
			super.execute();
		}
		
		override protected function packMessage():Object
		{
			var msg:InitInfoMessage = this.msg as InitInfoMessage;
			var data:Object = {};
			return data;
		}
		
		override public function onResponse(result:Object):void
		{
			var response:InitInfoResponse = new InitInfoResponse();
			response.parse(result);
			var event:GetServerResponseEvent = new GetServerResponseEvent(response, this.msg);
			dispatcher.dispatchEvent(event);
		}
	}
}