package org.robotlegs.demos.helloflash.view
{
	import org.robotlegs.demos.helloflash.controller.HelloFlashEvent;
	import org.robotlegs.demos.helloflash.model.StatsModel;
	import org.robotlegs.mvcs.Mediator;
	
	public class ReadoutMediator extends Mediator
	{
		[Inject]
		public var view:Readout;
		
		[Inject]
		public var statsModel:StatsModel;
		
		public function ReadoutMediator()
		{
			// Avoid doing work in your constructors!
			// Mediators are only ready to be used when onRegister gets called
		}
		
		override public function onRegister():void
		{
			// Listen to the context
			eventMap.mapListener(eventDispatcher, HelloFlashEvent.BALL_CLICKED, onBallClicked);
		}
		
		protected function onBallClicked(e:HelloFlashEvent):void
		{
			// Manipulate the view
			view.setText('Click count: ' + statsModel.ballClickCount);
		}
	}
}