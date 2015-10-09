package com.vox.game.breaktower.view.scene
{
	import com.vox.future.view.scene.BaseScene;
	import com.vox.game.breaktower.view.ui.CommonUI;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GButton;
	
	public class LoginScene extends BaseScene
	{
		/**大面板*/
		public var itm_ui:CommonUI;
		
		/**背景图片*/
		public var itm_background:Sprite;
		/**收集到了新的怪兽图鉴*/
		public var newbieTip2:MovieClip;
		/**点这里开始战斗*/
		public var newbieTip:MovieClip;
		
		/**宠物店*/
		public var itm_atlas:GButton;
		/**Boss战*/
		public var itm_boss:GButton ;
		/**天文馆*/
		public var itm_astronomy:GButton ;
		/**商店*/
		public var itm_shop:GButton ;
		
		/**中间的开始挑战按钮*/
		public var btn_fastBattle:GButton ;
		
		
		public function LoginScene(skin:*=null)
		{
			super( SRC_LoginScene ) ;
			
			newbieTip2.visible = false ;
			newbieTip.visible = false ;
		}
	}
}