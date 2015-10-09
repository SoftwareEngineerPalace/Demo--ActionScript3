package com.vox.view
{
	import com.vox.evt.HelloWorldMessage;
	import com.vox.model.HelloFlashModel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ReadMeMediator extends Mediator
	{
		[Inject]
		public var readMeView:ReadMe ;
		[Inject]
		public var appModel:HelloFlashModel ;
		
		public function ReadMeMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener( eventDispatcher, HelloWorldMessage.Ball_Clicked, onBallClickedHandler, HelloWorldMessage ) ;
		}
		
		private function onBallClickedHandler( $evt:HelloWorldMessage ):void
		{
			readMeView.updateText( appModel.ballClickedNum ) ;
		}
	}
}