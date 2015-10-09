package com.vox.command
{
	import com.vox.interfaces.ICommand;
	import com.vox.interfaces.IRedoableCommand;
	import com.vox.interfaces.IUndoableCommand;
	
	import flash.display.DisplayObject;
	
	public class ScaleUpCommand implements IUndoableCommand, IRedoableCommand
	{
		private var _receiver:DisplayObject ;
		
		public function ScaleUpCommand( $receiver:DisplayObject )
		{
			_receiver = $receiver ;
		}
		
		public function execute():void
		{
			_receiver.scaleX += 0.1 ;
			_receiver.scaleY += 0.1 ;
		}
		
		public function undo():void
		{
			_receiver.scaleX -= 0.1 ;
			_receiver.scaleY -= 0.1 ;
		}
		
		public function redo():void
		{
			execute() ;
		}
	}
}