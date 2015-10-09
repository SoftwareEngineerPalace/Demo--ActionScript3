package com.vox.context
{
	import com.vox.controller.CreateBallCommand;
	import com.vox.evt.AppContextEvent;
	import com.vox.model.AppModel;
	import com.vox.view.Ball;
	import com.vox.view.BallMediator;
	import com.vox.view.Readme;
	import com.vox.view.ReadmeMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	

	public class HelloFlashContext extends Context
	{
		public function HelloFlashContext( $contextView:DisplayObjectContainer = null, autoStartup:Boolean = true )
		{
			super( $contextView, autoStartup ) ;
		}
		
		override public function startup():void
		{
			commandMap.mapEvent( ContextEvent.STARTUP_COMPLETE, CreateBallCommand, ContextEvent, true ) ;
			commandMap.mapEvent( AppContextEvent.Ball_Clicked, CreateBallCommand, AppContextEvent ) ;
			
			injector.mapSingleton( AppModel ) ;
			
			mediatorMap.mapView( Ball, BallMediator ) ;
			mediatorMap.mapView( Readme, ReadmeMediator ) ;
			
			contextView.addChild( new Readme() ) ;
			
			super.startup() ;
		}
	}
}