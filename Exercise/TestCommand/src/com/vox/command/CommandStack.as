package com.vox.command
{
	import com.vox.interfaces.ICommand;

	public class CommandStack
	{
		private static var _instance:CommandStack ;
		private var _commands:Array ;
		private var _index:uint ;
		
		public function CommandStack( parameter:SingletonEnforcer )
		{
			_commands = []; 
			_index = 0 ;
		}
		
		public static function getInstance():CommandStack
		{
			if( !_instance ) _instance = new CommandStack( new SingletonEnforcer() ) ;
			return _instance ;
		}
		
		/**
		 * 在某个位置放入command, 把后面的command全部删掉
		 * @param command
		 */
		public function putCommand( command:ICommand ):void
		{
			_commands[ _index ++ ] = command ;
			_commands.splice( _index, _commands.length - _index ) ;
		}
		
		public function previous():ICommand 
		{
			return _commands[ -- _index ] ;
		}
		
		public function next():ICommand
		{
			return _commands[ ++ _index ] ;
		}
		
		public function hasPreviousCommands():Boolean
		{
			return _index > 0 ;
		}
		
		public function hasNextCommands():Boolean
		{
			return _index < _commands.length ;
		}
	}
}
class SingletonEnforcer{}