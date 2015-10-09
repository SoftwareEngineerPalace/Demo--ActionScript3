package
{
	import com.junkbyte.console.Cc;
	
	import flash.display.DisplayObject;

	public class Console
	{
		public static function init(root:DisplayObject):void
		{
			Cc.startOnStage(root, "\\");
			Cc.width = 600;
			Cc.height = 200;				
			Cc.commandLine = true;
			Cc.config.commandLineAllowed = true;			
		}
		
		public function Console(){}
	}
}