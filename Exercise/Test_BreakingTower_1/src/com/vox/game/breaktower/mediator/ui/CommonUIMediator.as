package com.vox.game.breaktower.mediator.ui
{
	import com.vox.future.managers.ModuleManager;
	import com.vox.game.breaktower.model.RoleModel;
	import com.vox.game.breaktower.net.types.GetBabelRoleInfo;
	import com.vox.game.breaktower.notification.evt.RoleInfoChangedEvent;
	import com.vox.game.breaktower.pub.ModuleConst;
	import com.vox.game.breaktower.view.ui.CommonUI;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class CommonUIMediator extends Mediator
	{
		[Inject]
		public var roleModel:RoleModel;
		
		public function get view():CommonUI
		{
			return ( viewComponent as CommonUI ) ;
		}
		
		public function CommonUIMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			view.mapListener( view.btn_help, MouseEvent.CLICK, onHelp ) ;
		}
		
		[MessageHandler]
		public function onRoleInfoChanged(msg:RoleInfoChangedEvent):void
		{
			updateView();
		}
		
		private function onHelp( $evt:MouseEvent ):void
		{
			trace ("ModuleManager.instance.getModule( ModuleConst.Module_Help ):", ModuleManager.instance.getModule( ModuleConst.Module_Help ));
			ModuleManager.instance.getModule( ModuleConst.Module_Help ).showModule();
		}
		
		private function updateView():void
		{
			view.tabChildren = view.tabEnabled = false ;
			var roleInfo:GetBabelRoleInfo = roleModel.roleInfo ;
			if( !roleInfo ) return ;
			view.txt_name.data = roleInfo.roleName;
		}
	}
}