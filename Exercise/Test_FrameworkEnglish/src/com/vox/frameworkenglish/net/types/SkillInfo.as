package com.vox.frameworkenglish.net.types
{
	import com.vox.future.request.BaseMessageType;

	public class SkillInfo extends BaseMessageType 
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean ;
		
		public var id:String ;
		public var typeId:int ;
		public var name:String ;
		public var price:int ;
		public var earned:Boolean ;
		public var equiped:Boolean;
		
		override public function pack():Object
		{
			var data:Object = {};
			data.id = this.id;
			data.typeId = this.typeId;
			data.name = this.name;
			data.price = this.price;
			data.earned = this.earned;
			data.equiped = this.equiped;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			this.success = data.success;
			this.id = data.id;
			this.typeId = data.typeId;
			this.name = data.name;
			this.price = data.price;
			this.earned = data.earned;
			this.equiped = data.equiped;
			return this;
		}
	}
}