package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 宠物信息
	 */
	public class RolePetInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 宠物id */
		public var petId:int;
		
		/** 拥有数量 */
		public var count:int;
		
		public function RolePetInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.petId = this.petId;
			data.count = this.count;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.petId = data.petId;
			
			this.count = data.count;
			return this;
		}
	}
}