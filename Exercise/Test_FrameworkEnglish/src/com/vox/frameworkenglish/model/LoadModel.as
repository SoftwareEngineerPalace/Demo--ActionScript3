package com.vox.frameworkenglish.model
{
	import com.vox.future.utils.MaskUtil;
	
	import flash.display.Stage;
	
	import ghostcat.manager.RootManager;
	import ghostcat.ui.controls.GPercentBar;

	/**
	 * 加载 数据模型
	 * @author jishu
	 */
	public class LoadModel
	{
		private var _loadProgressBar:GPercentBar ;
		public function updateProgress( $percent:Number ):void
		{
			if( !_loadProgressBar )
			{
				var stage:Stage = RootManager.stage ;//要总结
				_loadProgressBar = new GPercentBar( SRC_LoadProgressBar, false, GPercentBar.MOVIECLIP ) ;
				_loadProgressBar.percent = 0 ;
				_loadProgressBar.skin.txt_progress.text = "Loading...0%";
				_loadProgressBar.x = 184 ;
				_loadProgressBar.y = 234 ;
				stage.addChild( _loadProgressBar ) ;
				MaskUtil.addMask(); //要总结
			}
			_loadProgressBar.parent = $percent ;
			_loadProgressBar.skin.txt_progess.text = "Loading..." + int( $percent * 100 ) + "%" ; 
		}
		
		public function closeProgress():void
		{
			MaskUtil.removeMask();
			_loadProgressBar.destory() ;
			_loadProgressBar = null ;
		}
	}
}