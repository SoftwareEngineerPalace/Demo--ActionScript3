package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 每日任务
	 */
	public class DailyMissionInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var missionName:String;
		
		/** 任务简介 */
		public var missionDesc:String;
		
		/**  */
		public var rewardType:String;
		
		/**  */
		public var itemId:int;
		
		/**  */
		public var count:int;
		
		public function DailyMissionInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.missionName = this.missionName;
			data.missionDesc = this.missionDesc;
			data.rewardType = this.rewardType;
			data.itemId = this.itemId;
			data.count = this.count;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.missionName = data.missionName;
			
			this.missionDesc = data.missionDesc;
			
			this.rewardType = data.rewardType;
			
			this.itemId = data.itemId;
			
			this.count = data.count;
			return this;
		}
	}
}