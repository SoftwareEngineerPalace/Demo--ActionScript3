package com.vox.game.net
{
	import flash.utils.Dictionary;
	import com.vox.game.net.messages.InitInfoCommand;
	
	public class MessageType
	{
		private static var _commandDict:Dictionary = new Dictionary();
		/** 获取命令字典 */
		public static function get commandDict():Dictionary
		{
			return _commandDict;
		}
		_commandDict["InitInfo"] = InitInfoCommand;
		
		/**
		 * 推题
		 */
		public static const InitInfo:String = "InitInfo";
		
	}
}