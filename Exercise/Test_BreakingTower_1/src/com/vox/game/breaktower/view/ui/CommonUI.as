package com.vox.game.breaktower.view.ui
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.ui.GBuilderBase;
	import ghostcat.ui.controls.GButton;
	import ghostcat.ui.controls.GPercentBar;
	import ghostcat.ui.controls.GText;
	
	public class CommonUI extends GBuilderBase
	{
		//--------------------------tips-----------------------
		/**图鉴*/
		public var tip_tujian:MovieClip;
		/**选择课本的panel*/
		public var chooseBooksPnl:MovieClip ;
		
		//--------------------------信息显示部分 ---------------/
		/**大头像显示部分*/
		public var itm_info:Sprite;
		/**体力值*/
		public var itm_vitality:GPercentBar ;
		/**星星数*/
		public var itm_stars:GMovieClip ;
		/**姓名*/
		public var txt_name:GText ;
		
		//------------------------按钮----------------------
		/**排行按钮*/
		public var btn_rank:GButton ;
		/**角色按钮*/
		public var btn_role:GButton ;
		public var btn_gift:GButton ;
		public var btn_task:GButton ;
		public var btn_rob:GButton ;
		
		public var btn_toPK:GButton ;
		public var btn_sound:GButton ;
		public var btn_music:GButton ;
		public var btn_help:GButton ;
		public var btn_books_small:GButton ;
		public var btn_books:GButton ;
		public var btn_purchaseVitality:GButton ;
		public var btn_purchaseStar:GButton ;
		
		public function CommonUI(skin:*=null)
		{
			SRC_CommonUI ;
			super( skin ) ;
			trace();
			tip_tujian.visible = false ;
			chooseBooksPnl.visible = false ;
		}
	}
}