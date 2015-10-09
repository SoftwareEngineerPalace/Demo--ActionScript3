package com.vox.test.net.messages
{
	import com.vox.future.managers.ContextManager;
	import com.vox.future.request.BaseRequestMessage;
	import com.vox.future.services.GameCommonService;
	import com.vox.test.net.types.*;
	import com.vox.test.net.types.response.*;
	import com.vox.test.net.MessageType;
	
	/**
	 * 推题
	 */
	public class InitInfoMessage extends BaseRequestMessage
	{
		internal var _data:Object;
		
		
		override public function get url():String
		{
			var service:GameCommonService = ContextManager.context.getObjectByType(GameCommonService);
			return (service.domain + "/index.html");
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