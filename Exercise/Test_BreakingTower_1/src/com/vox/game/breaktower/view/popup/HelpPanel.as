package com.vox.game.breaktower.view.popup
{
	import com.vox.future.view.popup.BasePopup;
	import com.vox.future.view.popup.IPopupBehavior;
	import com.vox.future.view.popup.PopupConst;
	
	import ghostcat.ui.containers.GViewState;
	import ghostcat.ui.controls.GButton;
	
	/**
	 * 帮助面板
	 * @author jishu
	 */
	public class HelpPanel extends BasePopup
	{
		//-----------------------------------按钮------------------------------
		/**关闭按钮*/
		public var btn_close:GButton ;
		/**常见问题*/
		public var btn_FAQ:GButton ;
		/**新手问题*/
		public var btn_newbie:GButton ;
		
		/**状态机*/
		public var vs_content:GViewState ;
		
		
		public function HelpPanel( )
		{
			super(SRC_HelpPanel, false, null, PopupConst.BACK_POPUP );
		}
	}
}