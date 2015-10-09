package com.vox.frameworkenglish.net.types.responses
{
	import com.vox.future.request.BaseMessageType;

	/**
	 * 购买物品消息返回
	 * @author jishu
	 */
	public class BuyItemResponse extends BaseMessageType
	{
		public var success:Boolean ;
		/**最新的水果积分的数目*/
		public var crystal:int ;
		
		override public function pack():Object
		{
			var data:Object = { };
			data.crystal = this.crystal ;
			return data ;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if( !data ) return null ;
			this.success = data.success ;
			this.crystal = data.crystal ;
		}
	}
}