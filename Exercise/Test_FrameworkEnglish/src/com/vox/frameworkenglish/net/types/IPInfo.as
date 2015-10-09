package com.vox.frameworkenglish.net.types
{
	import com.vox.future.request.BaseMessageType;

	/**
	 * IP数据 
	 * @author jishu
	 */
	public class IPInfo extends BaseMessageType
	{
		/**返回值表示是否成功*/
		public var succes:Boolean ;
		/**IP的类型id*/
		public var typeId:int ;
		/**IP的名字*/
		public var name:String ;
		/**是否正在使用*/
		public var equiped:Boolean ;
		/**IP包含的角色类型*/
		public var roles:Array ;
		
		public function IPInfo()
		{
			super();
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.typeId = this.typeId ;
			data.name = this.name ;
			data.equiped = this.equiped ;
			data.roles = this.roles ;
			return data ;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if( !data ) return null ;
			this.succes = data.success ;
			this.typeId = data.typeId ;
			this.name = data.name ;
			this.equiped = data.equiped ;
			this.roles = parseArray( data.roles, false, "com.vox.frameworks.frameworkenglish.net.types.RoleInfo" ) ;
			return this ;
		}
	}
}