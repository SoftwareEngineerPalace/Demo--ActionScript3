package  com.vox.evt
{
	import flash.events.Event;
	
	public class AppContextEvent extends Event
	{
		public static const Ball_Clicked:String = "Ball_Clicked";
		private var _body:* ;
		
		public function AppContextEvent( $type:String, $body:* = null )
		{
			super( $type );
			_body = $body ;
		}
		
		public function get body():*
		{
			return _body ;
		}
		
		override public function clone():Event
		{
			return new AppContextEvent( type, body ) ;
		}
	}
}