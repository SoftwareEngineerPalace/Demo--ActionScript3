package com.vox.game.net.types
{
	import com.vox.game.net.types.*;
	import com.vox.game.net.types.response.*;
	
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 英语应用
	 */
	public class UnitLessonId extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 单元ID */
		public var unitId:String;
		
		/** 课ID */
		public var lessonId:String;
		
		public function UnitLessonId()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.unitId = this.unitId;
			data.lessonId = this.lessonId;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.unitId = data.unitId;
			
			this.lessonId = data.lessonId;
			return this;
		}
	}
}