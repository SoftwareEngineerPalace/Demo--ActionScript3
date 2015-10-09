package com.vox.frameworkenglish.vos
{
	import com.vox.frameworkenglish.net.types.IPInfo;
	import com.vox.frameworkenglish.utils.ResourceUtils;

	public class IPVO
	{
		/**
		 *IP信息 
		 */
		public var ipInfo:IPInfo ;
		
		/**
		 *当前角色id 
		 */
		public var curRoleId:String ;
		
		public function get iconUrl():String 
		{
			return ResourceUtils.toAbsoluteAssetsPath( ipInfo.typeId + "/icon.png" ) ;
		}
		
		public function get skinUrl():String
		{
			return ResourceUtils.toAbsoluteAssetsPath( ipInfo.typeId + "/skin.swf");
		}
	}
}