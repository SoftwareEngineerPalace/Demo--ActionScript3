package org.robotlegs.demos.helloflash.view
{
	import flash.events.MouseEvent;
	
	import org.robotlegs.demos.helloflash.controller.HelloFlashEvent;
	import org.robotlegs.demos.helloflash.model.StatsModel;
	import org.robotlegs.mvcs.Mediator;
	
	public class BallMediator extends Mediator
	{
		[Inject]
		public var view:Ball;
		
		[Inject]
		public var statsModel:StatsModel;
		
		public function BallMediator()
		{
			// Avoid doing work in your constructors!
			// Mediators are only ready to be used when onRegister gets called
		}
		
		override public function onRegister():void
		{
			// Listen to the view
			eventMap.mapListener(view, MouseEvent.CLICK, onClick);
			// Listen to the context
			eventMap.mapListener(eventDispatcher, HelloFlashEvent.BALL_CLICKED, onSomeBallClicked);
		}
		
		protected function onClick(e:MouseEvent):void
		{
			// Manipulate the model
			statsModel.recordBallClick();
			// Dispatch to context
			eventDispatcher.dispatchEvent(new HelloFlashEvent(HelloFlashEvent.BALL_CLICKED));
		}
		
		protected function onSomeBallClicked(e:HelloFlashEvent):void
		{
			// Manipulate the view
			view.poke();
		}
	}
}