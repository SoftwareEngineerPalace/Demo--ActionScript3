package
{
	import flash.display.Sprite;
	
	import org.robotlegs.demos.helloflash.HelloFlashContext;
	
	public class HelloFlash extends Sprite
	{
		protected var context:HelloFlashContext;
		
		public function HelloFlash()
		{
			context = new HelloFlashContext(this);
		}
	}
}