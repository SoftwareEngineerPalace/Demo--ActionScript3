package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 物品信息
	 */
	public class BabelItemInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var itemId:int;
		
		/**  */
		public var itemName:String;
		
		/** 物品描述 */
		public var itemDesc:String;
		
		/** 用星星购买售价 */
		public var starPrice:int;
		
		/** 用学豆购买售价 */
		public var integralPrice:int;
		
		public function BabelItemInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.itemId = this.itemId;
			data.itemName = this.itemName;
			data.itemDesc = this.itemDesc;
			data.starPrice = this.starPrice;
			data.integralPrice = this.integralPrice;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.itemId = data.itemId;
			
			this.itemName = data.itemName;
			
			this.itemDesc = data.itemDesc;
			
			this.starPrice = data.starPrice;
			
			this.integralPrice = data.integralPrice;
			return this;
		}
	}
}