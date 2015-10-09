package com.vox.game.breaktower.net
{
	import com.vox.game.breaktower.net.cmd.InitInfoCommand;
	
	import flash.utils.Dictionary;

	public class MessageType
	{
		public function MessageType()
		{
			
		}
		
		_commandDict["InitInfo"] = InitInfoCommand ;
		private static var _commandDict:Dictionary = new Dictionary();
		
		public static function get commandDict():Dictionary
		{
			return _commandDict ;
		}
		
		/**游戏初始化，包括角色信息，物品信息*/
		public static const InitInfo:String = "InitInfo" ;
	}
}