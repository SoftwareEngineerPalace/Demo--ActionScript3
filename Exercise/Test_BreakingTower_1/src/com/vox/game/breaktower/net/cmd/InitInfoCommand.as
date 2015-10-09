package com.vox.game.breaktower.net.cmd
{
	import com.vox.future.commands.GetServerResponseCommand;
	import com.vox.future.notifications.events.GetServerResponseEvent;
	import com.vox.future.request.BaseRequestCommand;
	import com.vox.future.request.BaseRequestMessage;
	import com.vox.game.breaktower.net.message.InitInfoMessage;
	import com.vox.game.breaktower.net.types.response.InitInfoResponse;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * 游戏初始化，包括角色信息，物品信息
	 * @author jishu
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
			var message:InitInfoMessage = BaseRequestMessage.requestMSG as InitInfoMessage ;
			this.msg = message ;
			message.data = "data=" + encodeURIComponent( JSON.stringify( this.packMessage() ) ) ;
			super.execute();
		}
		
		override public function onResponse(result:Object):void
		{
		    var response:InitInfoResponse = new InitInfoResponse();
			response.parse( result ) ;
			var evt:GetServerResponseEvent = new GetServerResponseEvent( response, this.msg ) ;
			dispatcher.dispatchEvent( evt ) ;
		}
		
		override protected function packMessage():Object
		{
			var msg:InitInfoMessage = this.msg as InitInfoMessage ;
			var data:Object = {};
			return data ;
		}
	}
}