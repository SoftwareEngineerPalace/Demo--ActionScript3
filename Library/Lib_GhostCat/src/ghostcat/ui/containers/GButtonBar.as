package ghostcat.ui.containers
{
	import ghostcat.ui.controls.GButton;
	/**
	 * 按钮条
	 * 
	 * 标签规则：子对象的render将会被作为子对象的默认skin
	 * 
	 * @author flashyiyi
	 * 
	 */
	public class GButtonBar extends GRepeater
	{
		public function GButtonBar(skin:*=null, replace:Boolean=true,ref:* = null,fields:Object = null)
		{
			if (!ref)
				ref = GButton;
			
			super(skin, replace,ref);
		}
	}
}