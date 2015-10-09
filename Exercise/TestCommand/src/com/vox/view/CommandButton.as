package com.vox.view
{
	import com.vox.command.CommandStack;
	import com.vox.interfaces.ICommand;
	
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	
	import ghostcat.ui.controls.GButton;
	
	public class CommandButton extends GButton
	{
		private var _command:ICommand ;
		
		public function CommandButton(label:String)
		{
			super();
			this.label = label 
			addEventListener( MouseEvent.CLICK, onClick ) ;
		}
		
		public function set command( value:ICommand ):void
		{
			_command = value ;
		}
		
		private function onClick( $evt:MouseEvent ):void
		{
			if( _command ) 
			{
				_command.execute() ;
				CommandStack.getInstance().putCommand( _command ) ;
			}
		}
	}
}