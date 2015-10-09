package com.vox.frameworkenglish.net.types
{
	import com.vox.future.request.BaseMessageType;

	public class RoleInfo extends BaseMessageType
	{
		public var success:Boolean;
		public var id:String ;
		public var typeId:int ;
		public var name:String;
		public var price:int ;
		public var earned:Boolean ;
		public var equiped:Boolean ;
		public var equipList:Array ;EquipInfo;// 打桩
		public var spriteList:Array ; SpriteInfo ;//打桩
		public var skillList:Array ; SkillInfo;//打桩
		
		override public function pack():Object
		{
			var data:Object = {};
			data.id = this.id ;
			data.typeId = this.typeId ;
			data.name = this.name ;
			data.price = this.price ;
			data.earned = this.earned ;
			data.equiped = this.equiped ;
			data.equipList = this.equipList ;
			data.spriteList = this.spriteList ;
			data.skillList = this.skillList ;
			return data;
		}
		
		override protected function parse(data:Object):BaseMessageType
		{
			if( !data ) return null;
			this.success = data.success ;
			this.id = data.id ;
			this.typeId = data.typeId ;
			this.name = data.name ;
			this.price = data.price ;
			this.earned = data.earned ;
			this.equiped = data.equiped ;
			this.equipList = parseArray( data.equipList, false, "com.vox.frameworkenglish.net.types.EquipInfo" );
			this.spriteList = parseArray( data.spriteList, false, "com.vox.frameworkenglish.net.types.SpriteInfo");
			this.skillList = parseArray( data.skillList, false, "com.vox.frameworkenglish.net.types.SkillInfo" ) ;
			return this ;
		}
	}
}