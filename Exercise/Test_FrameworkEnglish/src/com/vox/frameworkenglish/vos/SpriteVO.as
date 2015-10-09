package com.vox.frameworkenglish.vos
{
	import com.vox.frameworkenglish.net.types.SpriteInfo;

	public class SpriteVO implements IItemVO
	{
		/**
		 *精灵信息 
		 */
		public var spriteInfo:SpriteInfo ;
		/**
		 *所属角色的id 
		 */
		public var roleId:String ;
		/**
		 *所属ip的类型 
		 */
		public var ipTypeId:int ;
		
		
		public function get earnd():Boolean
		{
			return spriteInfo.earned;
		}
		
		public function get equiped():Boolean
		{
			// TODO Auto Generated method stub
			return false;
		}
		
		public function get id():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function get image():*
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function get name():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function get price():uint
		{
			// TODO Auto Generated method stub
			return 0;
		}
		
	}
}