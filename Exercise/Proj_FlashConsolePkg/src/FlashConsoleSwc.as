package
{
	import com.vox.future.commands.InitializeCommand;
	import com.vox.game.utils.FlashConsole;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.media.Sound;
	
	public class FlashConsoleSwc extends Sprite
	{
		[Embed(source="../raw/nokiatune.mp3")]
		public var NokiaTunesClass:Class ;
		public function FlashConsoleSwc()
		{
			super();	
		}
		
		public function initialize( $display:DisplayObject ):void
		{
			FlashConsole.initConsole( $display ) ;
			var sound:Sound = new NokiaTunesClass();
			sound.play() ;
		}
	}
}