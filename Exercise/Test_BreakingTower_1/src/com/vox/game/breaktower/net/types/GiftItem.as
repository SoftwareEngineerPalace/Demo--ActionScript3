package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 一条礼品记录
	 */
	public class GiftItem extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 收到礼物时间。排序用，亦作为查找使用 */
		public var receiveTime:String;
		
		/**  */
		public var itemId:int;
		
		/**  */
		public var count:int;
		
		/** 礼品类型，BABEL_ITEM,BABEL_STAR */
		public var rewardType:String;
		
		/** 送礼人的id */
		public var senderId:String;
		
		/** 送礼人的姓名 */
		public var senderName:String;
		
		public function GiftItem()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.receiveTime = this.receiveTime;
			data.itemId = this.itemId;
			data.count = this.count;
			data.rewardType = this.rewardType;
			data.senderId = this.senderId;
			data.senderName = this.senderName;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.receiveTime = data.receiveTime;
			
			this.itemId = data.itemId;
			
			this.count = data.count;
			
			this.rewardType = data.rewardType;
			
			this.senderId = data.senderId;
			
			this.senderName = data.senderName;
			return this;
		}
	}
}