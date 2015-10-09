package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * BOSS挑战获得的奖励。可以点击 领取 进行兑换
	 */
	public class BossPrizeInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 收到奖励的时间 */
		public var receiveTime:String;
		
		/** 随机唯一id，单个用户内唯一 */
		public var randomId:int;
		
		/** 奖励类型 */
		public var rewardType:String;
		
		/**  */
		public var itemId:String;
		
		/**  */
		public var count:int;
		
		public function BossPrizeInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.receiveTime = this.receiveTime;
			data.randomId = this.randomId;
			data.rewardType = this.rewardType;
			data.itemId = this.itemId;
			data.count = this.count;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.receiveTime = data.receiveTime;
			
			this.randomId = data.randomId;
			
			this.rewardType = data.rewardType;
			
			this.itemId = data.itemId;
			
			this.count = data.count;
			return this;
		}
	}
}