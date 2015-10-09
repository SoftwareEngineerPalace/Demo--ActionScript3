package com.vox.view
{
	import com.vox.message.HelloFlashMessage;
	import com.vox.model.HelloFlashModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class BallMediator extends Mediator
	{
		[Inject]
		public var model:HelloFlashModel ;
		[Inject]
		public var view:Ball; 
		
		public function BallMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			trace(view.getBounds(view));
			//view.addEventListener( MouseEvent.CLICK, onBallClick ) ;
			eventMap.mapListener( view, MouseEvent.CLICK, onBallClick, MouseEvent ) ;
			eventMap.mapListener( eventDispatcher, HelloFlashMessage.Ball_Clicked, onOtherBallClickedHandler ) ;
		}		
		
		private function onBallClick( $evt:MouseEvent = null ):void
		{
			model.recordBallClicked( ) ;
			eventDispatcher.dispatchEvent( new HelloFlashMessage( HelloFlashMessage.Ball_Clicked ) ) ;
		}
		
		private function onOtherBallClickedHandler( $evt:HelloFlashMessage ):void
		{
			view.poke() ;	
		}
	}
}