package com.vox.game.breaktower.net.types
{
	import com.vox.future.request.BaseMessageType;
	
	/**
	 * 通天塔星星汇率
	 */
	public class BabelStarExchangeRate extends BaseMessageType
	{
		/** 返回值时表示是否成功 */
		public var success:Boolean;
		
		/** 通天塔星星 */
		public var babelStarCount:int;
		
		/** 阿分提星星 */
		public var afentiStarCount:int;
		
		/** 学豆 */
		public var integralCount:int;
		
		public function BabelStarExchangeRate()
		{
			super();
			
		}
		
		override public function pack():Object
		{
			var data:Object = {};
			data.babelStarCount = this.babelStarCount;
			data.afentiStarCount = this.afentiStarCount;
			data.integralCount = this.integralCount;
			return data;
		}
		
		override public function parse(data:Object):BaseMessageType
		{
			if(data == null) return null;
			super.parse(data);
			this.success = data.success;
			
			this.babelStarCount = data.babelStarCount;
			
			this.afentiStarCount = data.afentiStarCount;
			
			this.integralCount = data.integralCount;
			return this;
		}
	}
}