package
{
	import com.vox.context.HelloFlashContext;
	
	import flash.display.Sprite;
	
	public class HelloFlash extends Sprite
	{
		protected var context:HelloFlashContext;
		
		public function HelloFlash()
		{
			context = new HelloFlashContext(this);
		}
	}
}