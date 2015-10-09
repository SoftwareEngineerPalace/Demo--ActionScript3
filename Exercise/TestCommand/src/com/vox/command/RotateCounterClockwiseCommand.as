package com.vox.command
{
	import com.vox.interfaces.ICommand;
	import com.vox.interfaces.IRedoableCommand;
	import com.vox.interfaces.IUndoableCommand;
	
	import flash.display.DisplayObject;
	
	public class RotateCounterClockwiseCommand implements IUndoableCommand, IRedoableCommand
	{
		private var _receiver:DisplayObject ;
		
		public function RotateCounterClockwiseCommand( $receiver:DisplayObject )
		{
			_receiver = $receiver ;
		}
		
		public function execute():void
		{
			_receiver.rotation -= 20 ;
		}
		
		public function undo():void
		{
			_receiver.rotation += 20 ;
		}
		
		public function redo():void
		{
			execute() ;
		}
	}
}