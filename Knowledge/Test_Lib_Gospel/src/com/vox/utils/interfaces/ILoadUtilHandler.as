package com.vox.utils.interfaces
{
	/**
	 * 功能： 加载工具控制器的接口，加载器开始加载后返回该接口的实例，通过该接口可以控制加载，比如取消加载
	 * @author 肖建军
	 */
	public interface ILoadUtilHandler
	{
		/**清理加载， 如果正在加载中则取消加载，且不调用任何回调*/
		function clearLoad():void ;
	}
}