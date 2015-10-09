package module
{
	import com.vox.future.module.BaseModule;
	import com.vox.future.module.IModule;
	import com.vox.game.breaktower.mediator.popup.HelpPanelMediator;
	import com.vox.game.breaktower.view.popup.HelpPanel;
	
	import flash.utils.Dictionary;

	/**
	 * 帮助模块
	 * @author jishu
	 */
	public class HelpModule extends BaseModule
	{
		private var _view:HelpPanel ; 
		
		public function HelpModule()
		{
			super();
		}
		
		override public function listMediatorDict():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			dict[ HelpPanel ] = HelpPanelMediator ;
			return dict ;
		}
		
		override public function closeModule():IModule
		{
			if( _view )
			{
				_view.close();
			}
			return this ;
		}
		
		override public function showModule(data:*=null):IModule
		{
			_view = new HelpPanel();
			_view.show();
			this.view = _view ;
			return this ;
		}
		
	}
}