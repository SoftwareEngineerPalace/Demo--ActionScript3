package com.vox.frameworkenglish.model
{
	import com.vox.frameworkenglish.vos.EquipVO;
	
	import flash.utils.Dictionary;

	/**
	 * 装备数据摸型 
	 * @author jishu
	 * 
	 */
	public class EquipModel
	{
		/**装备列表 里面放EquipVO*/
		private var _equipList:Array = [];
		/**放装备的dic*/
		private var _equipDict:Dictionary = new Dictionary();
		/**装备类型的dic*/
		private var _equipTypeDict:Dictionary = new Dictionary();
		/**装备角色的dic*/
		private var _equipRoleDict:Dictionary = new Dictionary();
		
		public function get equipList():Array
		{
			return _equipList ;
		}
		
		public function addEquip( $value:EquipVO ):void
		{
			if( !_equipDict[ $value.id] ) //先检查一下_equipDict 要没有 想添加起来的这个装备
			{
				//1 全装备列表
				_equipList.push( $value ) ;
				//2 装备实例ID字典
				_equipDict[$value.id] = $value ;
				//3 装备类型ID字典
				_equipTypeDict[$value.] = $value ;
				//4 查一下这个角色的所有装备字典
				var roleEquipsArr:Array = _equipRoleDict[$value.roleId] ;
				if( !roleEquipsArr ) //如果这个角色没有任何装备
				{
					roleEquipsArr = [];
					_equipRoleDict[$value.roleId] = roleEquipsArr
				}
				roleEquipsArr.push( $value ) ;
				//5 检测当前装备
				this.checkCurrentEquip( $value ) ;
			}
		}
		
		private function checkCurrentEquip( $equipVO:EquipVO ):void
		{
			if( !$equipVO.equiped ) return ;
			var roleModel
			
		}
	}
}