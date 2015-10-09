package com.vox.frameworkenglish.net.messages
{
	import com.vox.future.managers.ContextManager;
	import com.vox.future.request.BaseRequestMessage;
	import com.vox.future.services.GameCommonService;

	public class BuyItemMessage extends BaseRequestMessage
	{
		internal var _data:Object ;
		/**要购买的物品的ID*/
		public var id:String ;
		
		public function BuyItemMessage()
		{
			super( 
		}
		
		override public function get data():Object
		{
			return super.data;
		}
		
		override public function get url():String
		{
			var service:GameCommonService = ContextManager.context.getObjectByType(GameCommonService);
			return ( service.domain + "/flash/ENGLISH/app/api/buyitem.vpage");
		}
	}
}