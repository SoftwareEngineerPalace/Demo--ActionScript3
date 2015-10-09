package com.vox.frameworkenglish.vos
{
	import com.vox.frameworkenglish.net.types.SkillInfo;

	/**
	 *技能数据类型 
	 * @author jishu
	 * 
	 */
	public class SkillVO implements IItemVO 
	{
		/**角色信息*/
		public var skillInfo:SkillInfo ;
		public var roleId:String ;
		public var ipTypeId:uint ;
		
		public function get earnd():Boolean
		{
			return this.skillInfo.earned ;
		}
		
		public function get equiped():Boolean
		{
			return skillInfo.equiped ;
		}
		
		public function get id():String
		{
			return skillInfo.id ;
		}
		
		public function get image():*
		{
			/*var ipModel:IPModel = ContextManager.context.getObjectByType(IPModel);
			return ipModel.getSkinClass(spellInfo.typeId);*/
		}
		
		public function get name():String
		{
			return skillInfo.name ;
		}
		
		public function get price():uint
		{
			return skillInfo.price ;
		}
	}
}