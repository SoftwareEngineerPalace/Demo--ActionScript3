package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 可送礼品
	 */
	public class SendableGiftList extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var giftId:int;
		
		/** BABEL_ITEM,BABEL_STAR */
		public var rewardType:String;
		
		/** rewadrType为BABEL_ITEM时，此字段表示道具id */
		public var itemId:int;
		
		public function SendableGiftList()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.giftId = this.giftId;
			data.rewardType = this.rewardType;
			data.itemId = this.itemId;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.giftId = data.giftId;
			
			this.rewardType = data.rewardType;
			
			this.itemId = data.itemId;
			return this;
		}
	}
}