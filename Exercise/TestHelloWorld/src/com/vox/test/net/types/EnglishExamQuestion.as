package com.vox.test.net.types
{
	import com.vox.test.net.types.*;
	import com.vox.test.net.types.response.*;
	
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 英语应试题
	 */
	public class EnglishExamQuestion extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var bookId:String;
		
		/**  */
		public var cid:String;
		
		/** 题目ID */
		public var eid:String;
		
		/** 知识点 */
		public var ek:String;
		
		/** 预期通过率 */
		public var weight:Number;
		
		/** 算法版本 */
		public var alogv:String;
		
		public function EnglishExamQuestion()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.bookId = this.bookId;
			data.cid = this.cid;
			data.eid = this.eid;
			data.ek = this.ek;
			data.weight = this.weight;
			data.alogv = this.alogv;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.bookId = data.bookId;
			
			this.cid = data.cid;
			
			this.eid = data.eid;
			
			this.ek = data.ek;
			
			this.weight = data.weight;
			
			this.alogv = data.alogv;
			return this;
		}
	}
}