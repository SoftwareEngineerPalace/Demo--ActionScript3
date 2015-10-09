
package org.robotlegs.demos.helloflash
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.demos.helloflash.controller.CreateBallCommand;
	import org.robotlegs.demos.helloflash.controller.HelloFlashEvent;
	import org.robotlegs.demos.helloflash.model.StatsModel;
	import org.robotlegs.demos.helloflash.view.Ball;
	import org.robotlegs.demos.helloflash.view.BallMediator;
	import org.robotlegs.demos.helloflash.view.Readout;
	import org.robotlegs.demos.helloflash.view.ReadoutMediator;
	import org.robotlegs.mvcs.Context;
	
	public class HelloFlashContext extends Context
	{
		public function HelloFlashContext(contextView:DisplayObjectContainer)
		{
			super(contextView);
		}
		
		override public function startup():void
		{
			// Map some Commands to Events
			commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, CreateBallCommand, ContextEvent, true);
			commandMap.mapEvent(HelloFlashEvent.BALL_CLICKED, CreateBallCommand, HelloFlashEvent );
			// Create a rule for Dependency Injection
			injector.mapSingleton(StatsModel);
			
			// Here we bind Mediator Classes to View Classes:
			// Mediators will be created automatically when
			// view instances arrive on stage (anywhere inside the context view)
			mediatorMap.mapView(Ball, BallMediator);
			mediatorMap.mapView(Readout, ReadoutMediator);
			
			// Manually add something to stage
			contextView.addChild(new Readout());
			
			// And we're done
			super.startup();
		}
	
	}
}