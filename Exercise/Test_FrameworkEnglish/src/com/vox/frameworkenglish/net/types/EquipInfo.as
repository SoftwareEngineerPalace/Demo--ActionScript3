package com.vox.frameworkenglish.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 装备的基本数据，里面还加了pack和parse两个方法 
	 * @author jishu
	 */
	public class EquipInfo extends BaseMessageType
	{
		
		/**
		 * 返回值时表示是否成功
		 */
		public var succes:Boolean ;
		public var id:String ;
		public var name:String ;
		public var price:int ;
		public var typeId:int ;
		public var earned:Boolean ;
		public var equiped:Boolean ;
		
		public function EquipInfo()
		{
			super();
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.id = this.id ;
			data.typeId = this.typeId ;
			data.name = this.name ;
			data.prize = this.price ;
			data.earned = this.earned ;
			data.equiped = this.equiped ;
			return data ;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if( !data ) return null ;
			this.succes = data.success ;
			this.id = data.id ;
			this.typeId = data.typeId ;
			this.name = data.name ;
			this.price = data.prize ;
			this.earned = data.earned ;
			this.equiped = data.equiped ;
			return this ;
		}
	}
}