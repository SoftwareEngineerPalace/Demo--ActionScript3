package event
{
	import flash.events.Event;
	
	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-2下午5:58:48
	 *
	 */
	public class LoginEvent extends Event
	{
		public static const OPEN:String = '0';
		public static const LOGIN:String = '1';
		public static const CONNECT:String = '2';
		
		public var data:Object;
		public function LoginEvent(type:String,data:Object=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		
		//override 需要重写clone() 这里省略了。。。自己写啊
	}
}