package com.vox.view
{
	import com.vox.evt.AppContextEvent;
	import com.vox.model.AppModel;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class ReadmeMediator extends Mediator
	{
		[Inject]
		public var readmeVew:Readme ;
		[Inject]
		public var appModel:AppModel;
		
		public function ReadmeMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			trace("注册上Readme");
			eventMap.mapListener( eventDispatcher, AppContextEvent.Ball_Clicked, onBallClicked ) ;
		}
		
		protected function onBallClicked( $evt:AppContextEvent ):void
		{
			readmeVew.setText( "click count: " + appModel.ballClickedCount ) ;
		}
		
		
	}
}