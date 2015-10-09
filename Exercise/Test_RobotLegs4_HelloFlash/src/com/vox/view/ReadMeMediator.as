package com.vox.view
{
	import com.vox.message.HelloFlashMessage;
	import com.vox.model.HelloFlashModel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ReadMeMediator extends Mediator
	{
		[Inject]
		public var model:HelloFlashModel ;
		
		[Inject]
		public var readme:ReadMe ;
		
		public function ReadMeMediator()
		{
			super();
		}
		
		private function initialize():void
		{
			onBallClickedHandler();
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			initialize();
			
			eventMap.mapListener( eventDispatcher, HelloFlashMessage.Ball_Clicked, onBallClickedHandler ) ;
		}
		
		private function onBallClickedHandler( $evt:HelloFlashMessage = null ):void
		{
			readme.updateTxt( "点击次数: " + model.ballClickedNum ) ;
		}
		
	}
}