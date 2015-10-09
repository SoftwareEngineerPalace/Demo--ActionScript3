package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * pk物品信息
	 */
	public class PkItemInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var id:String;
		
		/**  */
		public var swf:String;
		
		/**  */
		public var img:String;
		
		/**  */
		public var name:String;
		
		/**  */
		public var desc:String;
		
		public function PkItemInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.id = this.id;
			data.swf = this.swf;
			data.img = this.img;
			data.name = this.name;
			data.desc = this.desc;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.id = data.id;
			
			this.swf = data.swf;
			
			this.img = data.img;
			
			this.name = data.name;
			
			this.desc = data.desc;
			return this;
		}
	}
}