package com.vox.frameworkenglish.model
{
	import com.vox.frameworkenglish.vos.RoleVO;
	
	import flash.utils.Dictionary;

	/**
	 * 角色数据模型
	 * @author jishu
	 */
	public class RoleModel
	{
		private var _roleList:Array = [];
		/**角色都放到这里面*/
		private var _roleDict:Dictionary = new Dictionary();
		/**角色类型都放到这里面*/
		private var _roleTypeDict:Dictionary = new Dictionary();
		/**角色的IP都放到这里面, 每一个值其实是一个Array*/
		private var _roleIPDict:Dictionary = new Dictionary();
		
		public function get roleList():Array
		{
			return _roleList ;
		}
		
		internal function addRole( $value:RoleVO ):void
		{
			if( !_roleDict[$value.id] )
			{
				//把所有的角色VO都放到这个数组中
				_roleList.push( $value ) ;
				//角色实例ID字典
				_roleIPDict[ $value.id ] = $value ;
				//角色类型ID字典
				_roleTypeDict[ $value.id ] ] = $value ;
				//角色IP字典
				var ipRoles:Array = _roleIPDict[$value.ipTypeId];
				if( !ipRoles )
				{
					ipRoles = [];
					_roleIPDict[$value.ipTypeId] = ipRoles ;
				}
				ipRoles.push( $value ) ;
				this
			}
		}
	}
}