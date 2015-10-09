package com.vox.game.breaktower.model
{
	import com.vox.future.managers.ContextManager;
	import com.vox.game.breaktower.net.message.InitInfoMessage;
	import com.vox.game.breaktower.net.types.GetBabelRoleInfo;
	import com.vox.game.breaktower.net.types.response.InitInfoResponse;
	import com.vox.game.breaktower.notification.evt.RoleInfoChangedEvent;
	
	import org.robotlegs.mvcs.Actor;
	
	public class RoleModel extends Actor
	{
		private var _roleInfo:GetBabelRoleInfo;
		
		public function RoleModel()
		{
			super();
		}
		
		/** 获取角色信息 */
		public function get roleInfo():GetBabelRoleInfo
		{
			return _roleInfo;
		}
		
		[CommandResult]
		public function onInitInfo(response:InitInfoResponse, request:InitInfoMessage):void
		{
			if( response.success )
			{
				_roleInfo = response.roleInfo;
				trace("接收到InitInfoResponse");
				// 派发事件
				ContextManager.context.dispatchEvent(new RoleInfoChangedEvent(RoleInfoChangedEvent.Role_Info_Changed_Event, _roleInfo));
			}
		}
	}
}