package com.vox.frameworkenglish.vos
{
	import com.vox.frameworkenglish.net.types.RoleInfo;

	public class RoleVO implements IItemVO
	{
		public var roleInfo:RoleInfo ;
		public var ipTypeId:uint ;
		public var curEquipId:String ;
		public var curSpriteId:String ;
		public var curSkillId:String ;
		
		public function RoleVO()
		{
		}
		
		public function get id():String
		{
			return roleInfo.id;
		}
		
		public function get name():String
		{
			return roleInfo.name ;
		}
		
		public function get image():*
		{
			/*var ipModel:IPModel = ContextManager.context.getObjectByType(IPModel);
			return ipModel.getSkinClass(roleInfo.typeId);*/
		}
		
		public function get price():uint
		{
			return roleInfo.price ;
		}
		
		public function get earned():Boolean
		{
			return roleInfo.earned ;
		}
		
		public function get equiped():Boolean
		{
			return roleInfo.equiped ;
		}
	}
}