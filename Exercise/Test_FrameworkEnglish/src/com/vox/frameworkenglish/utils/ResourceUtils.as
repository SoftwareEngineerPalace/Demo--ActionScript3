package com.vox.frameworkenglish.utils
{
	import com.vox.future.utils.PathUtil;

	public class ResourceUtils
	{
		public function ResourceUtils()
		{
		}
		
		/**
		 * 转换为绝对的资源路径
		 * @param $url
		 */
		public static function toAbsoluteAssetsPath( $url:* ):void
		{
			CONFIG::DEVs
			{
				return PathUtil.wrapFlashURL( "assets/" + $url ) ;
			}
			CONFIG::RELEASE
			{
				return PathUtil.wrapFlashURL( "assets/FramewokEnglish/" + $url ) ;
			}
		}
	}
}