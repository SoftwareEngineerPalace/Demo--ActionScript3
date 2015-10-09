package module.login
{
	import robotlegs.bender.bundles.mvcs.Mediator;
	import event.LoginEvent;
	import service.LoginService;
	import module.login.model.LoginModel;
	
	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午6:02:42
	 *
	 */
	public class LoginMediator extends Mediator
	{
		[Inject]
		public var ser:LoginService;
		
		[Inject]
		public var view:LoginView;
		
		[Inject]
		public var model:LoginModel;
		
		public function LoginMediator()
		{
			super();
		}
		
		public override function initialize():void
		{
			super.initialize();
			this.addViewListener(LoginEvent.LOGIN,loginRequest);
			ser.signal_login.add(loginHandler);
		}
		
		public override function destroy():void
		{
			super.destroy();
			//....
		}
		
		private function loginRequest(e:LoginEvent):void
		{
			ser.requestLogin(e.data.id,e.data.password);
		}
		
		/**
		 *登陆成功 
		 * 
		 */		
		private function loginHandler():void
		{
			//抛出事件，对应事件的commond会得到相应，而打开相应面板，可以根据（model里面返回的值知道是否存在角色），然后决定打开创建角色或者加载场景
			//if(model.hasrole)
			//this.eventDispatcher.dispatchEvent(....
			//else
			
			
			//如果是一般模块的点击按钮 给服务端发送消息后 收到的返回信息
			//则可以在这里调用view，传入model。将结果显示在界面。
			//view.show(model);
		}
	}
}