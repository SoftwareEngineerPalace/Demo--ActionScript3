package module.login
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import event.LoginEvent;
	import module.login.model.LoginModel;
	import interfaces.ILogin;
	
	/**
	 *登陆面板
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午6:02:23
	 *
	 */
	public class LoginView extends Sprite implements ILogin
	{
		public static var inst:LoginView = new LoginView();
		public function LoginView()
		{
			super();
			this.graphics.beginFill(0);
			this.graphics.drawCircle(10,10,20);
			this.graphics.endFill();
			
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(evt:MouseEvent):void
		{
			this.dispatchEvent(new LoginEvent(LoginEvent.LOGIN,{id:111,password:'louissong111'}));
		}
		
		public function show(model:LoginModel):void
		{
			var tf:TextField = new TextField();
			tf.text = model.roleID + model.roleName;
			this.addChild(tf);
			tf.x = tf.y = 100;
		}
	}
}