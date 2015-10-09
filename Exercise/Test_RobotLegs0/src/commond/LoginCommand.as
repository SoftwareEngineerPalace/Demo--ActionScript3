package commond
{
	import robotlegs.bender.extensions.commandCenter.api.ICommand;
	import robotlegs.bender.extensions.contextView.ContextView;
	import module.login.LoginView;
	
	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午6:01:20
	 *
	 */
	public class LoginCommand implements ICommand
	{
		[Inject]
		public var mainViw:MainView;
		/**
		 *这个类就是用来打开或者关闭面板的 
		 * 具体的逻辑操作 在mediator里面实现即可
		 */		
		public function LoginCommand()
		{
		}
		
		public function execute():void
		{
			var view:LoginView = LoginView.inst;
			if(mainViw.UILayer.contains(view))
				mainViw.UILayer.removeChild(view);
			else
				mainViw.UILayer.addChild(view);
		}
	}
}