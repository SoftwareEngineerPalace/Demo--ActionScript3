package com.vox.game.net.types.response
{
	import com.vox.game.net.types.*;
	import com.vox.game.net.types.response.*;
	
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 游戏初始化，包括角色信息，物品信息
	 */
	public class InitInfoResponse extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 可能值：NO_PK_ROLE(需要跳转去创建pk角色),ALREADY_DONE(已经完成了今天的任务),ALL_DONE(15天的任务已经全部完成了) */
		public var failReason:String;
		
		/**  */
		public var userId:String;
		
		/**  */
		public var bookId:String;
		
		/** 可能值：1,2 分别表示英语应试 和 英语应用 */
		public var questionType:int;
		
		/**
		 * questionType值为ENGLISH_APP时，此处有值
		 * EnglishAppQuestion 类型的数组
		 */
		public var appQuestionList:Array;EnglishAppQuestion;// 打桩
		
		/**
		 * questionType值为ENGLISH_EXAM时,此处有值
		 * EnglishExamQuestion 类型的数组
		 */
		public var examQuestionList:Array;EnglishExamQuestion;// 打桩
		
		public function InitInfoResponse()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.failReason = this.failReason;
			data.userId = this.userId;
			data.bookId = this.bookId;
			data.questionType = this.questionType;
			data.appQuestionList = this.appQuestionList.pack();
			data.examQuestionList = this.examQuestionList.pack();
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.failReason = data.failReason;
			
			this.userId = data.userId;
			
			this.bookId = data.bookId;
			
			this.questionType = data.questionType;
			
			this.appQuestionList = parseArray(data.appQuestionList, false, "com.vox.game.net.types.EnglishAppQuestion");
			
			this.examQuestionList = parseArray(data.examQuestionList, false, "com.vox.game.net.types.EnglishExamQuestion");
			return this;
		}
	}
}