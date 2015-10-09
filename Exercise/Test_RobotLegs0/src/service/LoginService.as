package service
{
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;
	
	import proto.login.UserInfoRequest;
	import proto.login.UserInfoResponse;
	import core.net.Server;
	import module.login.model.LoginModel;

	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午5:55:43
	 *
	 */
	public class LoginService
	{
		[Inject]
		public var model:LoginModel;
		private var _server:Server;
		
		public var signal_login:Signal = new Signal();
		public function LoginService()
		{
			_server = Server.inst;
			
			//添加回调函数
			_server.addCallFunc(1001,loginHandler);
		}
		
		/**
		 *请求登陆 
		 * 
		 */		
		public function requestLogin(id:String,password:String):void
		{
			var userID : UserInfoRequest = new UserInfoRequest();
			userID.id = id;
			userID.password = password;
			//...验证码神马的看需要了
			_server.sendMsg(1001,userID);//1001为协议号
		}
		
		/**
		 *登陆返回 
		 * @param bytes
		 * 
		 */		
		private function loginHandler(bytes:ByteArray):void
		{
			var data:UserInfoResponse = new UserInfoResponse();
			data.mergeFrom(bytes);//解析成proto数据
			model.init(data);//把数据存入model
			signal_login.dispatch();//抛出事件，监听了次signal的地方会收到消息(一般是每个模块的mediator)
		}
	}
}