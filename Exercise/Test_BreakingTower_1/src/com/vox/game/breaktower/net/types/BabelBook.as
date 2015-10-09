package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 通天塔书
	 */
	public class BabelBook extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 书本ID */
		public var id:String;
		
		/** 书名 */
		public var cname:String;
		
		/** 封皮显示内容 */
		public var viewContent:String;
		
		/** 封皮显示颜色 */
		public var color:String;
		
		public function BabelBook()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.id = this.id;
			data.cname = this.cname;
			data.viewContent = this.viewContent;
			data.color = this.color;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.id = data.id;
			
			this.cname = data.cname;
			
			this.viewContent = data.viewContent;
			
			this.color = data.color;
			return this;
		}
	}
}