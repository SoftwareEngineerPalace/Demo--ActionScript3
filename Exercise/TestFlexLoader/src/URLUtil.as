package
{
	import flash.net.URLVariables;

	public class URLUtil
	{
		/**
		 * 去除多余的"/"
		 */
		public static function trim($url:String):String
		{
			return $url.replace(/(?<!:)\/{2,}/g, "/");
		}
		
	}
}