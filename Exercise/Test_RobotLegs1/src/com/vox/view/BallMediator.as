package com.vox.view
{
	import com.vox.context.HelloFlashContext;
	import com.vox.evt.AppContextEvent;
	import com.vox.model.AppModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class BallMediator extends Mediator
	{
		[Inject]
		public var ball:Ball ;
		[Inject]
		public var appModel:AppModel
		
		public function BallMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			trace("注册上Ball");
			eventMap.mapListener( ball, MouseEvent.CLICK, onClick ) ;
			eventMap.mapListener( eventDispatcher, AppContextEvent.Ball_Clicked, onSomeBallClicked ) ;
		}
		
		protected function onClick( $evt:MouseEvent = null ):void
		{
			appModel.recordBallClick() ;
			eventDispatcher.dispatchEvent( new AppContextEvent( AppContextEvent.Ball_Clicked ) ) ;
		}
		
		protected function onSomeBallClicked( $evt:AppContextEvent ):void
		{
			ball.poke() ;
		}
	}
}