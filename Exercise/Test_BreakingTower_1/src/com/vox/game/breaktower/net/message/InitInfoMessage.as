package com.vox.game.breaktower.net.message
{
	import com.vox.future.managers.ContextManager;
	import com.vox.future.request.BaseRequestMessage;
	import com.vox.future.services.GameCommonService;
	import com.vox.game.breaktower.net.MessageType;
	
	/**游戏初始化的消息 ，包括角色信息，物品信息 本质就是一个Event*/
	public class InitInfoMessage extends BaseRequestMessage
	{
		internal var _data:Object ;
		
		public function InitInfoMessage( )
		{
			super( MessageType.InitInfo );
		}
		
		override public function get data():Object
		{
			return _data ;
		}
		
		public function set data( $value:Object ):void
		{
			_data = $value ;
		}
		
		override public function get url():String
		{
			var service:GameCommonService = ContextManager.context.getObjectByType( GameCommonService ) ;
			var url:String = service.domain +　"/student/babel/api/load/initInfo.vpage" ;
			return url ;
		}
	}
}