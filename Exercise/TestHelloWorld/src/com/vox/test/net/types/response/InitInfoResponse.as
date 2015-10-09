package com.vox.test.net.types.response
{
	import com.vox.test.net.types.*;
	import com.vox.test.net.types.response.*;
	
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 初始数据
	 */
	public class InitInfoResponse extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var classId:String;
		
		/**  */
		public var message:String;
		
		/**
		 * 学生数组
		 * Student 类型的数组
		 */
		public var list:Array;Student;// 打桩
		
		public function InitInfoResponse()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.classId = this.classId;
			data.message = this.message;
			data.list = this.list.pack();
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.classId = data.classId;
			
			this.message = data.message;
			
			this.list = parseArray(data.list, false, "com.vox.test.net.types.Student");
			return this;
		}
	}
}