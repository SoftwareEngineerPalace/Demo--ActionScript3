package com.vox.view
{
	import com.vox.evt.HelloWorldMessage;
	import com.vox.model.HelloFlashModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class BallMediator extends Mediator
	{
		[Inject]
		public var appModel:HelloFlashModel ;
		[Inject]
		public var ballView:Ball ;
		
		
		public function BallMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			eventMap.mapListener( ballView, MouseEvent.CLICK, onBallClickedHandler ) ;
			//ballView.addEventListener( MouseEvent.CLICK, onBallClickedHandler ) ;
			//eventMap.mapListener( eventDispatcher, MouseEvent.CLICK, onBallClickedHandler, MouseEvent ) ;
			eventMap.mapListener( eventDispatcher, HelloWorldMessage.Ball_Clicked, onOtherBallClickedHandler, HelloWorldMessage ) ;
		}
		
		private function onBallClickedHandler( $evt:MouseEvent ):void
		{
			appModel.increaseBallClickedNum() ;
			eventDispatcher.dispatchEvent( new HelloWorldMessage( HelloWorldMessage.Ball_Clicked,  ballView) ) ;
		}
		
		private function onOtherBallClickedHandler( $message:HelloWorldMessage ):void
		{
			ballView.poke() ;	
		}
	}
}