package com.vox.frameworkenglish.vos
{
	import com.vox.frameworkenglish.net.types.EquipInfo;

	/**
	 * 装备的数据类型
	 * @author jishu
	 */
	public class EquipVO implements IItemVO
	{
		/**
		 *装备信息 
		 */
		public var equipInfo:EquipInfo ;
		/**
		 *角色id 
		 */
		public var roleId:String ;
		/**
		 *所属IP类型id 
		 */
		public var ipTypeId:int ;
		
		public function get earnd():Boolean
		{
			return equipInfo.earned ;
		}
		
		public function get equiped():Boolean
		{
			return equipInfo.equiped ;
		}
		
		public function get id():String
		{
			return equipInfo.id ;
		}
		
		public function get image():*
		{
			/*var ipModel:IPModel = ContextManager.context.getObjectByType(IPModel);
			return ipModel.getSkinClass(equipInfo.typeId);*/
		}
		
		public function get name():String
		{
			return equipInfo.name ;
		}
		
		public function get price():uint
		{
			return equipInfo.price ;
		}
	}
}