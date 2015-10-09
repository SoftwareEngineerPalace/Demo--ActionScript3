package com.vox.context
{
	import com.vox.command.CreateBallCmd;
	import com.vox.evt.HelloWorldMessage;
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
			mediatorMap.mapView( Ball, BallMediator ) ;
			mediatorMap.mapView( ReadMe, ReadMeMediator ) ;
			
			commandMap.mapEvent( HelloWorldMessage.Ball_Clicked, CreateBallCmd, HelloWorldMessage, false ) ;
			commandMap.mapEvent( ContextEvent.STARTUP_COMPLETE, CreateBallCmd, ContextEvent, true ) ;
			
			injector.mapSingleton( HelloFlashModel ) ;
			//injector.mapSingleton( Ball ) ;
			
			contextView.addChild( new ReadMe() ) ;
			
			super.startup();
		}
	}
}