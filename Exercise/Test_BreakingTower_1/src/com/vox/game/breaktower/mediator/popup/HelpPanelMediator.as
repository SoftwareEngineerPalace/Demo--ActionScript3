package com.vox.game.breaktower.mediator.popup
{
	import com.vox.future.view.mediators.BasePopupMediator;
	import com.vox.future.view.popup.PopupEvent;
	import com.vox.game.breaktower.view.popup.HelpPanel;
	
	import flash.events.MouseEvent;
	
	import org.flexunit.asserts.fail;
	import org.robotlegs.mvcs.Mediator;
	
	public class HelpPanelMediator extends BasePopupMediator
	{
		public function HelpPanelMediator()
		{
			super();
		}
		
		public function get view():HelpPanel
		{
			return ( viewComponent as HelpPanel ) ;
		}
		
		override public function onAfterShow(event:PopupEvent):void
		{
			view.tabChildren = view.tabEnabled = false ;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			view.mapListener( view.btn_close, MouseEvent.CLICK, onClose ) ;
		}
		
		override public function onRemove():void
		{
			super.onRemove();
		}
		
		private function onClose( $evt:MouseEvent ):void
		{
			view.close();
		}
	}
}