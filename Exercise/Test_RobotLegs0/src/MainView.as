package
{
	import flash.display.Sprite;
	
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	/**
	 *
	 *@author Louis_Song <br />
	 *创建时间：2013-5-3上午11:22:10
	 *
	 */
	public class MainView extends Sprite
	{
		private var _context:IContext;
		private var _TopLayer:Sprite;
		private var _UILayer:Sprite;
		private var _BackgroundLayer:Sprite;
		public function MainView()
		{
			_context = new Context().install(MVCSBundle).configure(AppConfig).configure(new ContextView(this));
			_context.injector.map(MainView).toValue(this);
			
			_BackgroundLayer = new Sprite();
			this.addChild(_BackgroundLayer);
			
			_UILayer = new Sprite();
			this.addChild(UILayer);
			
			_TopLayer = new Sprite();
			this.addChild(_TopLayer);
		}

		public function get UILayer():Sprite
		{
			return _UILayer;
		}

		public function get BackgroundLayer():Sprite
		{
			return _BackgroundLayer;
		}

		public function get TopLayer():Sprite
		{
			return _TopLayer;
		}
	}
}