package
{
	import com.vox.sample.CommandExample;
	
	import flash.display.Sprite;
	
	public class TestCommand extends Sprite
	{
		public function TestCommand()
		{
			var example:CommandExample = new CommandExample();
			
			addChild( example ) ;
		}
	}
}