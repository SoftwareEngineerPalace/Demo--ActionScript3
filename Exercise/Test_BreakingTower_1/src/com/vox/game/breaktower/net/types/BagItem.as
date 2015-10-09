package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 一个背包物品栏
	 */
	public class BagItem extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var itemId:int;
		
		/**  */
		public var count:int;
		
		public function BagItem()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.itemId = this.itemId;
			data.count = this.count;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.itemId = data.itemId;
			
			this.count = data.count;
			return this;
		}
	}
}