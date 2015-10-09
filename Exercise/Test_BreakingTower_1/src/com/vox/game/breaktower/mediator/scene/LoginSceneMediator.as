package com.vox.game.breaktower.mediator.scene
{
	import com.vox.future.view.mediators.BaseSceneMediator;
	import com.vox.future.view.scene.BaseScene;
	import com.vox.game.breaktower.view.scene.LoginScene;
	
	public class LoginSceneMediator extends BaseSceneMediator
	{
		public function LoginSceneMediator()
		{
			super();
		}
		
		public function get view():LoginScene
		{
			return ( viewComponent as LoginScene ) ;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.tabChildren = view.tabEnabled = false ;
		}
		
		override public function onSwitchIn(fromScene:BaseScene, data:*):void
		{
			trace("进入LoginScene");
			super.onSwitchIn(fromScene, data);
		}
		
		
	}
}