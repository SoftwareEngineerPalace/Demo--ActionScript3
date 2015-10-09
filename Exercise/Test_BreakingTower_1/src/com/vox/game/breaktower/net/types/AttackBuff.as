package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 攻击加成系数
	 */
	public class AttackBuff extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** PLANT,ANIMAL,NATURAL,SUPER_POWER */
		public var attack:String;
		
		/** PLANT,ANIMAL,NATURAL,SUPER_POWER */
		public var defense:String;
		
		/**  */
		public var buff:Number;
		
		public function AttackBuff()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.attack = this.attack;
			data.defense = this.defense;
			data.buff = this.buff;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.attack = data.attack;
			
			this.defense = data.defense;
			
			this.buff = data.buff;
			return this;
		}
	}
}