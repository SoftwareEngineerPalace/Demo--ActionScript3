package com.vox.game.breaktower.notification.evt
{
	import com.vox.game.breaktower.net.types.GetBabelRoleInfo;
	
	import flash.events.Event;
	
	/**
	 * 角色信息变更事件
	 * @author jishu
	 */
	public class RoleInfoChangedEvent extends Event
	{
		public static const Role_Info_Changed_Event:String = "Role_Info_Changed_Event" ;
		
		/**最新的角色信息*/
		public var roleInfo:GetBabelRoleInfo ;
		
		public function RoleInfoChangedEvent( $type:String, $roleInfo:GetBabelRoleInfo )
		{
			this.roleInfo = $roleInfo ;
			super( type );
		}
	}
}