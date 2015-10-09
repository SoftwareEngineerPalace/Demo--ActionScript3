package com.vox.game.net.messages
{
	import com.vox.future.managers.ContextManager;
	import com.vox.future.request.BaseRequestMessage;
	import com.vox.future.services.GameCommonService;
	import com.vox.game.net.types.*;
	import com.vox.game.net.types.response.*;
	import com.vox.game.net.MessageType;
	
	/**
	 * 推题
	 */
	public class InitInfoMessage extends BaseRequestMessage
	{
		internal var _data:Object;
		
		
		override public function get url():String
		{
			var service:GameCommonService = ContextManager.context.getObjectByType(GameCommonService);
			return (service.domain + "/student/wintermission/initInfo.vpage");
		}
		
		override public function get data():Object
		{
			return _data;
		}
		
		public function InitInfoMessage()
		{
			super(MessageType.InitInfo);
			
		}
	}
}