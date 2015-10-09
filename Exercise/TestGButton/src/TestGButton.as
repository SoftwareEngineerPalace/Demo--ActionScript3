package
{
	import flash.display.Sprite;
	
	import ghostcat.ui.controls.GButton;
	
	public class TestGButton extends Sprite
	{
		public function TestGButton()
		{
			var btn:GButton = new GButton(ITM_Cell );
			addChild( btn ) ;
			btn.label = "测"　;
		}
	}
}