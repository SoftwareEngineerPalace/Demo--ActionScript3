package com.vox.future.utils
{
	/**
	 * 功能: 作为FlashConsole的中间人存在，防止由于直接引用FlashConsole导致体积增大
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class FlashConsoleCommonValue
	{
		/** Console日志缓存数组 */
		public static var cachedLogs:Array = [];
	}
}