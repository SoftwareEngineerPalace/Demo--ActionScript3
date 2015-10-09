package com.vox.sample
{
	import com.vox.command.CommandStack;
	import com.vox.command.RotateClockwiseCommand;
	import com.vox.command.RotateCounterClockwiseCommand;
	import com.vox.command.ScaleDownCommand;
	import com.vox.command.ScaleUpCommand;
	import com.vox.interfaces.ICommand;
	import com.vox.interfaces.IRedoableCommand;
	import com.vox.interfaces.IUndoableCommand;
	import com.vox.view.CommandButton;
	import com.vox.view.CommandContainer;
	import com.vox.view.Rectangle;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ghostcat.ui.controls.GButton;
	
	public class CommandExample extends Sprite
	{
		public function CommandExample()
		{
			super();
			
			var rect:Rectangle = new Rectangle( 0x000000, 50 ) ;
			rect.x = 200 ;
			rect.y = 200 ;
			addChild( rect ) ;
			
			var btn:CommandButton = new CommandButton( "apply command");
			addChild( btn ) ;
			btn.y = 250 ;
			
			var container:CommandContainer = new CommandContainer( new RotateClockwiseCommand( rect ) , "rotate clockwise", 0, 0 ) ;
			addChild( container ) ;
			
			container = new CommandContainer( new RotateCounterClockwiseCommand( rect ), "rotate counter-clockwise", 0, 55 ) ;
			addChild( container ) ;
			
			container = new CommandContainer( new ScaleUpCommand( rect ), "scale up", 0, 110 ) ;
			addChild( container ) ;
			
			container = new CommandContainer( new ScaleDownCommand( rect ), "scale down", 0, 165 ) ;
			addChild( container ) ;
			
			var undoBtn:GButton = new GButton() ;
			undoBtn.label = "undo" ;
			addChild( undoBtn ) ;
			undoBtn.y = 280 ;
			undoBtn.addEventListener( MouseEvent.CLICK, onUndo ) ;
			
			var redoBtn:GButton = new GButton() ;
			redoBtn.label = "redo" ;
			addChild( redoBtn ) ;
			redoBtn.y = 310 ;
			redoBtn.addEventListener( MouseEvent.CLICK, onRedo ) ;
		}
		
		private function onUndo( $evt:MouseEvent ):void
		{
			var stack:CommandStack = CommandStack.getInstance() ;
			if( stack.hasPreviousCommands() )
			{
				var command:ICommand = stack.previous() ;
				if( command is IUndoableCommand ) 
				{
					IUndoableCommand( command ).undo() ;
				}
			}
		}
		
		private function onRedo( $evt:MouseEvent ):void
		{
			var stack:CommandStack = CommandStack.getInstance() ;
			if( stack.hasNextCommands() )
			{
				var command:ICommand = stack.next() ;
				if( command is IRedoableCommand )
				{
					IRedoableCommand( command ).redo() ;
				}
			}
		}
	}
}