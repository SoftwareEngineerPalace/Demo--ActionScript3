package com.vox.context
{
	import com.vox.command.CreateBallCommand;
	import com.vox.message.HelloFlashMessage;
	import com.vox.model.HelloFlashModel;
	import com.vox.view.Ball;
	import com.vox.view.BallMediator;
	import com.vox.view.ReadMe;
	import com.vox.view.ReadMeMediator;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;
	
	public class HelloFlashContext extends Context
	{
		public function HelloFlashContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			// TODO Auto Generated method stub
			mediatorMap.mapView( Ball, BallMediator ) ;
			mediatorMap.mapView( ReadMe, ReadMeMediator ) ;
			
			commandMap.mapEvent( ContextEvent.STARTUP_COMPLETE, CreateBallCommand, ContextEvent, true ) ;
			commandMap.mapEvent( HelloFlashMessage.Ball_Clicked, CreateBallCommand, HelloFlashMessage ) ;
			
			injector.mapSingleton( HelloFlashModel ) ;
			
			contextView.addChild( new ReadMe() ) ;
			
			super.startup();
		}
	}
}