package com.vox
{
	import flash.events.Event;
	
	public class CurStateEvent extends Event
	{
		public static const Current_Id:String = "Current_Id";
		public var id:uint ;
		private var _type:String ;
		
		public function CurStateEvent( $type:String, $id:int )
		{
			super( $type, true ) ;
			this.id = $id ;
			this._type = $type ;
		}
		
		override public function clone():Event
		{
			return new CurStateEvent( _type, id ) ;
		}
	}
}