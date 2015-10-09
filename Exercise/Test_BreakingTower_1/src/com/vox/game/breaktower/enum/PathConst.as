package com.vox.game.breaktower.enum
{
	import com.vox.future.commands.InitializeCommand;

	public class PathConst
	{
		/**swf资源路径*/
		public static var swfPath:String = "/resources/apps/flash/pk/assets/swf/";
		/**头像路径*/
		public static var imgPath:String = "/resources/apps/flash/pk/assets/img/";
		
		public function PathConst()
		{
		}
		
		public static function initializ( $domain:String ):void
		{
			swfPath = $domain + swfPath ;
			imgPath = $domain + imgPath ;
		}
	}
}