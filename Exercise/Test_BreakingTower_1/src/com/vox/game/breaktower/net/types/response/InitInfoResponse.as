package com.vox.game.breaktower.net.types.response
{
	import com.vox.future.request.BaseMessageType;
	import com.vox.game.breaktower.net.types.AttackBuff;
	import com.vox.game.breaktower.net.types.BabelBook;
	import com.vox.game.breaktower.net.types.BabelItemInfo;
	import com.vox.game.breaktower.net.types.BabelPetInfo;
	import com.vox.game.breaktower.net.types.BabelStarExchangeRate;
	import com.vox.game.breaktower.net.types.DailyMissionInfo;
	import com.vox.game.breaktower.net.types.GetBabelRoleInfo;
	import com.vox.game.breaktower.net.types.PkItemInfo;
	import com.vox.game.breaktower.net.types.*;
	import com.vox.game.breaktower.net.types.response.*;
	
	/**
	 * 游戏初始化，包括角色信息，物品信息
	 */
	public class InitInfoResponse extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 如果success为false，此字段表示失败原因。目前有两个取值: NO_PK_ROLE , HOMEWORK_NOT_FINISHED */
		public var failReason:String;
		
		/** 角色信息 */
		public var roleInfo:GetBabelRoleInfo;
		
		/**全部物品列表BabelItemInfo 类型的数组 */
		public var itemList:Array;BabelItemInfo;// 打桩
		
		/**AttackBuff 类型的数组 */
		public var attackBuff:Array; AttackBuff;// 打桩
		
		/**全部宠物列表 BabelPetInfo 类型的数组*/
		public var petList:Array;BabelPetInfo;// 打桩
		
		/**每日任务信息 DailyMissionInfo 类型的数组 */
		public var dailyMission:Array;DailyMissionInfo;// 打桩
		
		/** 汇率  BabelStarExchangeRate 类型的数组*/
		public var babelStarExchangeRate:Array;BabelStarExchangeRate;// 打桩
		
		/** 用于save类消息的加密 */
		public var secureKey:String;
		
		/** 全部PK装备 PkItemInfo 类型的数组 */
		public var pkItemList:Array;PkItemInfo;// 打桩
		
		/** 是否需要换英语书 如果为true需弹出换书提示，用户不可游戏 */
		public var needChangeEnglishBook:Boolean;
		
		/** 是否需要更换数学书 如果为true需弹出换书提示，用户不可游戏 */
		public var needChangeMathBook:Boolean;
		
		/** 英语书*/
		public var englishBook:BabelBook;
		
		/** 数学书*/
		public var mathBook:BabelBook;
		
		/** 是否阿分提地区 */
		public var afentiOpen:Boolean;
		
		/** 是否阿分提用户（是否付费了） */
		public var afentiUser:Boolean;
		
		/** 用户是否设置了支付密码 */
		public var hasPassword:Boolean;
		
		/** 当前开放的最大楼层 */
		public var maxFloor:int;
		
		public function InitInfoResponse()
		{
			super();
			this.roleInfo = new GetBabelRoleInfo();
			this.englishBook = new BabelBook();
			this.mathBook = new BabelBook();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.failReason = this.failReason;
			data.roleInfo = this.roleInfo.pack();
			data.itemList = this.itemList.pack();
			data.attackBuff = this.attackBuff.pack();
			data.petList = this.petList.pack();
			data.dailyMission = this.dailyMission.pack();
			data.babelStarExchangeRate = this.babelStarExchangeRate.pack();
			data.secureKey = this.secureKey;
			data.pkItemList = this.pkItemList.pack();
			data.needChangeEnglishBook = this.needChangeEnglishBook;
			data.needChangeMathBook = this.needChangeMathBook;
			data.englishBook = this.englishBook.pack();
			data.mathBook = this.mathBook.pack();
			data.afentiOpen = this.afentiOpen;
			data.afentiUser = this.afentiUser;
			data.hasPassword = this.hasPassword;
			data.maxFloor = this.maxFloor;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.failReason = data.failReason;
			
			this.roleInfo = new GetBabelRoleInfo().parse(data.roleInfo) as GetBabelRoleInfo;
			
			this.itemList = parseArray(data.itemList, false, "com.vox.game.breaktower.net.types.BabelItemInfo");
			
			this.attackBuff = parseArray(data.attackBuff, false, "com.vox.game.breaktower.net.types.AttackBuff");
			
			this.petList = parseArray(data.petList, false, "com.vox.game.breaktower.net.types.BabelPetInfo");
			
			this.dailyMission = parseArray(data.dailyMission, false, "com.vox.game.breaktower.net.types.DailyMissionInfo");
			
			this.babelStarExchangeRate = parseArray(data.babelStarExchangeRate, false, "com.vox.game.breaktower.net.types.BabelStarExchangeRate");
			
			this.secureKey = data.secureKey;
			
			this.pkItemList = parseArray(data.pkItemList, false, "com.vox.game.breaktower.net.types.PkItemInfo");
			
			this.needChangeEnglishBook = data.needChangeEnglishBook;
			
			this.needChangeMathBook = data.needChangeMathBook;
			
			this.englishBook = new BabelBook().parse(data.englishBook) as BabelBook;
			
			this.mathBook = new BabelBook().parse(data.mathBook) as BabelBook;
			
			this.afentiOpen = data.afentiOpen;
			
			this.afentiUser = data.afentiUser;
			
			this.hasPassword = data.hasPassword;
			
			this.maxFloor = data.maxFloor;
			return this;
		}
	}
}