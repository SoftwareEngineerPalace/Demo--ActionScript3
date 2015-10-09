package
{
	import commond.LoginCommand;
	
	import core.net.Server;
	
	import event.LoginEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import module.login.LoginMediator;
	import module.login.LoginView;
	import module.login.model.LoginModel;
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	
	import service.LoginService;
	
	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午5:36:37
	 *
	 */
	public class AppConfig implements IConfig
	{
		[Inject]
		public var context:IContext;
		[Inject]
		public var commandMap:IEventCommandMap;
		[Inject]
		public var mediatorMap:IMediatorMap;
		[Inject]
		public var contextView:ContextView;
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		public function AppConfig()
		{
		}
		
		public function configure():void
		{
			context.logLevel = LogLevel.DEBUG;//输出日志
			
			
			//所有的模块model在这里声明
			context.injector.map(LoginModel).asSingleton();
			//角色model
			//背包model
			//阵型model
			//.....
			
			//。。。service 通信部分
			var service:LoginService = new LoginService();
			context.injector.map(LoginService).toValue(service);
			context.injector.injectInto(service);
			//角色service
			//背包service
			//阵型service
			//.....
			
			
			//commond
			commandMap.map(LoginEvent.OPEN).toCommand(LoginCommand);
			commandMap.map(LoginEvent.LOGIN, LoginCommand ) ;
			//角色commond
			//背包command
			//阵型command
			//.....
			
			
			//mediator绑定view
			mediatorMap.map(LoginView).toMediator(LoginMediator);
			//角色view
			//背包view
			//阵型view
			//.....
			
			
			Server.inst.addEventListener(LoginEvent.CONNECT,connectHandler);
			//...各种error什么的 ，继续在下面侦听（需要在server里面抛出相应事件）
			
			//框架搞完了，连接服务器，请求ooxx吧
			Server.inst.connect('192.168.1.80',8800);
		}
		
		/**
		 *连接服务器成功（连接失败或断开socket神马的，可以走和连接成功一样的流程，写在次函数后面） 
		 * @param evt
		 * 
		 */		
		private function connectHandler(evt:LoginEvent):void
		{
			//连接成功了，此处相当于一个没有框架的新项目的构造函数了。可以以此为入口 大展拳脚了
			//。。。。
			//加载资源配置文件。。。
			//。。。。
			
			//我在这里请求打开登陆面板，commond的execute会触发
			eventDispatcher.dispatchEvent(new LoginEvent(LoginEvent.OPEN));
		}
	}
}