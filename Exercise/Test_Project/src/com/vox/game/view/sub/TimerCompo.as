package com.vox.game.view.sub
{
	import ghostcat.ui.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GPercentBar;
	
	public class TimerCompo extends GBuilderBase
	{
		public var pbr_time:GPercentBar;
		public var btn_start:GButton ;
		
		public function TimerCompo(skin:*=null)
		{
			super(SRC_GameScene);
		}
	}
}