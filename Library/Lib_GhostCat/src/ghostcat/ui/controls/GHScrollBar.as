package ghostcat.ui.controls
{
	import ghostcat.skin.HScrollBarSkin;
	import ghostcat.ui.UIConst;
	
	/**
	 * 横向滚动条
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GHScrollBar extends GScrollBar
	{
		public static var defaultSkin:* = HScrollBarSkin;
		
		public function GHScrollBar(skin:*=null, replace:Boolean=true, fields:Object=null,replaceSkin:*=null)
		{
			if (!skin)
				skin = defaultSkin;
			
			super(skin, replace, fields,replaceSkin);
		
			this.direction = UIConst.HORIZONTAL;
		}
	}
}