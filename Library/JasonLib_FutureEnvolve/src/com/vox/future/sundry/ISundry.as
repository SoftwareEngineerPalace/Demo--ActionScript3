package com.vox.future.sundry
{
	/**
	 * 功能: 杂项接口， 里面收罗了所有系统可能会用到的杂项数据或方法.
	 * @author jishu
	 */
	public interface ISundry
	{
		/**添加消息请求时的遮罩*/
		function addRequestMask( $request:* ):void ;
		
		/**移除消息请求时的遮罩*/
		function removeRequestMask( $request:* ):void ;
	}
}