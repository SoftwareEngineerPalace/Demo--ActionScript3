package com.vox.view
{
	import com.vox.interfaces.ICommand;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class CommandContainer extends Sprite
	{
		private var _command:ICommand;
		private var _x:Number ;
		private var _y:Number ;
		public function CommandContainer( $command:ICommand, $labelText:String, xValue:Number, yValue:Number )
		{
			// store a reference to the command object
			_command = $command ;
			
			// draw a rectangle 
			graphics.lineStyle();
			graphics.beginFill( 0x990000, 1 ) ;
			graphics.drawRect( 0, 0, 50, 50 ) ;
			graphics.endFill() ;
			
			//create a textfield to use as the label
			var label:TextField = new TextField();
			label.width = 50 ;
			label.height = 50 ;
			label.multiline = true ;
			label.wordWrap = true ;
			label.text = $labelText ;
			label.selectable = false ;
			addChild( label ) ;
			
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown ) ;
			addEventListener( MouseEvent.MOUSE_UP, onMouseUp ) ;
			
			_x = xValue ;
			_y = yValue ;
			x = _x ;
			y = _y ;
		}
		
		private function onMouseDown( $evt:MouseEvent ):void
		{
			startDrag();
		}
		
		private function onMouseUp( $evt:MouseEvent ):void
		{
			stopDrag() ;
			x = _x ;
			y = _y ;
			
			var target:DisplayObject = dropTarget ;
			while( target != null && !(target is CommandButton ) && target!= root )
			{
				target = target.parent ;
			}
			
			if( target is CommandButton )
			{
				CommandButton( target ).command = _command ;
			}
		}
	}
	
}