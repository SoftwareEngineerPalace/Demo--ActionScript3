package
{
	import com.vox.future.utils.FlashConsole;
	import com.vox.future.utils.KeyPasswordUtil;
	import com.vox.gospel.utils.LoadUtil;
	import com.vox.gospel.utils.PathUtil;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Demo_FlashConsole extends Sprite
	{
		public function Demo_FlashConsole()
		{
					
		}
		
		private var _flashConsoleLoaded:Boolean ;
		private function initializeFlashConsole():void
		{
			CONFIG::DEVs
			{
				FlashConsole.initConsole( this ) ;
			}
			CONFIG::RELEASE
			{
				var stage:Stage = this.stage ;
				PathUtil.initialize( stage.loaderInfo.parameters ) ;
				KeyPasswordUtil.initialize( stage ) ;
				KeyPasswordUtil.addMap( "console", function():void
				{
					if( _flashConsoleLoaded ) return ;
					LoadUtil.loaderLoad( PathUtil.wrapFlashURL("assets/FlashConsoleSwc?t=" + new Date().time ), function( $loader:Loader ):void
					{
						var pack:Sprite = $loader.content as Sprite ;
						pack["initialize"][stage] ;
						_flashConsoleLoaded = true ;
					});
				});
			}
		}
	}
}