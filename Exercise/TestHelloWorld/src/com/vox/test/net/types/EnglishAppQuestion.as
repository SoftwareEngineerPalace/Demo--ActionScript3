package com.vox.test.net.types
{
	import com.vox.test.net.types.*;
	import com.vox.test.net.types.response.*;
	
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 英语应用
	 */
	public class EnglishAppQuestion extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 题型 */
		public var appType:String;
		
		/** 题型id */
		public var practiceId:int;
		
		/**
		 * 与content对应的课程id
		 * UnitLessonId 类型的数组
		 */
		public var unitLessonIdList:Array;UnitLessonId;// 打桩
		
		/** 题列表。一个AppQuestion对应一个类型，其下可能有多个题 */
		public var content:String;
		
		public function EnglishAppQuestion()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.appType = this.appType;
			data.practiceId = this.practiceId;
			data.unitLessonIdList = this.unitLessonIdList.pack();
			data.content = this.content;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.appType = data.appType;
			
			this.practiceId = data.practiceId;
			
			this.unitLessonIdList = parseArray(data.unitLessonIdList, false, "com.vox.test.net.types.UnitLessonId");
			
			this.content = data.content;
			return this;
		}
	}
}