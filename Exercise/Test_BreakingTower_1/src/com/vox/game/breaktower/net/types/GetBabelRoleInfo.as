package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 获取用户角色信息
	 */
	public class GetBabelRoleInfo extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/**  */
		public var roleId:String;
		
		/**  */
		public var roleName:String;
		
		/** 职业 WARRIOR等 */
		public var roleCareer:String;
		
		/** MALE,FEMALE */
		public var gender:String;
		
		/**  */
		public var maxHp:int;
		
		/** 头像url */
		public var avatar:String;
		
		/**  */
		public var vitality:int;
		
		/**  */
		public var starCount:int;
		
		/**  */
		public var keyCount:int;
		
		/** 学豆数 */
		public var integral:int;
		
		/** 阿分提星星数 */
		public var afentiStarCount:int;
		
		/** 用户可达最高楼层 */
		public var floor:int;
		
		/** 打通的最大关卡号 */
		public var stageIndex:int;
		
		/** 用户去过的最高楼层 */
		public var beenToFloor:int;
		
		/** 用户去过的最大关卡号，与beenToFloor,seenNpcIndex共同决定图鉴的可见数目 */
		public var beenToStageIndex:int;
		
		/** 用户去过的最大关卡号中见过的npc，与beenToFloor,beenToStageIndex共同决定图鉴的可见数目 */
		public var seenNpcIndex:int;
		
		/**
		 * 
		 * BagItem 类型的数组
		 */
		public var itemList:Array;BagItem;// 打桩
		
		/**
		 * 全部礼物列表,flash用于显示时请倒序遍历
		 * GiftItem 类型的数组
		 */
		public var giftList:Array;GiftItem;// 打桩
		
		/**
		 * 用户拥有的宠物列表
		 * RolePetInfo 类型的数组
		 */
		public var petList:Array;RolePetInfo;// 打桩
		
		/**
		 * 用户尚未兑换的BOSS挑战奖品
		 * BossPrizeInfo 类型的数组
		 */
		public var bossPrizeList:Array;BossPrizeInfo;// 打桩
		
		/**
		 * 剩余的可送礼品列表
		 * SendableGiftList 类型的数组
		 */
		public var sendableGiftList:Array;SendableGiftList;// 打桩
		
		/**
		 * 已播放的引导动画ID
		 * int 类型的数组
		 */
		public var playedIntroAnimation:Array;int;// 打桩
		
		/** 年级。低于3年级的学生不能进行boss战 */
		public var grade:int;
		
		public function GetBabelRoleInfo()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.roleId = this.roleId;
			data.roleName = this.roleName;
			data.roleCareer = this.roleCareer;
			data.gender = this.gender;
			data.maxHp = this.maxHp;
			data.avatar = this.avatar;
			data.vitality = this.vitality;
			data.starCount = this.starCount;
			data.keyCount = this.keyCount;
			data.integral = this.integral;
			data.afentiStarCount = this.afentiStarCount;
			data.floor = this.floor;
			data.stageIndex = this.stageIndex;
			data.beenToFloor = this.beenToFloor;
			data.beenToStageIndex = this.beenToStageIndex;
			data.seenNpcIndex = this.seenNpcIndex;
			data.itemList = this.itemList.pack();
			data.giftList = this.giftList.pack();
			data.petList = this.petList.pack();
			data.bossPrizeList = this.bossPrizeList.pack();
			data.sendableGiftList = this.sendableGiftList.pack();
			data.playedIntroAnimation = packArray(this.playedIntroAnimation);
			data.grade = this.grade;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.roleId = data.roleId;
			
			this.roleName = data.roleName;
			
			this.roleCareer = data.roleCareer;
			
			this.gender = data.gender;
			
			this.maxHp = data.maxHp;
			
			this.avatar = data.avatar;
			
			this.vitality = data.vitality;
			
			this.starCount = data.starCount;
			
			this.keyCount = data.keyCount;
			
			this.integral = data.integral;
			
			this.afentiStarCount = data.afentiStarCount;
			
			this.floor = data.floor;
			
			this.stageIndex = data.stageIndex;
			
			this.beenToFloor = data.beenToFloor;
			
			this.beenToStageIndex = data.beenToStageIndex;
			
			this.seenNpcIndex = data.seenNpcIndex;
			
			this.itemList = parseArray(data.itemList, false, "com.vox.game.breaktower.net.types.BagItem");
			
			this.giftList = parseArray(data.giftList, false, "com.vox.game.breaktower.net.types.GiftItem");
			
			this.petList = parseArray(data.petList, false, "com.vox.game.breaktower.net.types.RolePetInfo");
			
			this.bossPrizeList = parseArray(data.bossPrizeList, false, "com.vox.game.breaktower.net.types.BossPrizeInfo");
			
			this.sendableGiftList = parseArray(data.sendableGiftList, false, "com.vox.game.breaktower.net.types.SendableGiftList");
			
			this.playedIntroAnimation = parseArray(data.playedIntroAnimation, true, "com.vox.game.breaktower.net.types.PlayedIntroAnimation");
			
			this.grade = data.grade;
			return this;
		}
	}
}