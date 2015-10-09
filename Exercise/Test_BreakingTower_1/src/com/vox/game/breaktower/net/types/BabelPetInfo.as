package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 宠物信息
	 */
	public class BabelPetInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var id:int;
		
		/** 宠物名 */
		public var petName:String;
		
		/** PLANT,ANIMAL,NATURAL,SUPER_POWER */
		public var attackType:String;
		
		/** 所属地图 */
		public var mapNo:int;
		
		public function BabelPetInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.id = this.id;
			data.petName = this.petName;
			data.attackType = this.attackType;
			data.mapNo = this.mapNo;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.id = data.id;
			
			this.petName = data.petName;
			
			this.attackType = data.attackType;
			
			this.mapNo = data.mapNo;
			return this;
		}
	}
}