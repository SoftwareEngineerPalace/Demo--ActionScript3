package com.vox.test.net.types
{
	import com.vox.test.net.types.*;
	import com.vox.test.net.types.response.*;
	
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 学生
	 */
	public class Student extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var name:String;
		
		/**  */
		public var id:String;
		
		public function Student()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.name = this.name;
			data.id = this.id;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.name = data.name;
			
			this.id = data.id;
			return this;
		}
	}
}