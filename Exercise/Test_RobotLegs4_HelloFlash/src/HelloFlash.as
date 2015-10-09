package
{
	import com.vox.context.HelloFlashContext;
	
	import flash.display.Sprite;
	
	[SWF(width="700",height="470",backgroundColor="0xffffff")]
	public class HelloFlash extends Sprite
	{
		public function HelloFlash()
		{
			initialize();
		}
		
		private function initialize():void
		{
			var context:HelloFlashContext = new HelloFlashContext( this ) ;
		}
	}
}