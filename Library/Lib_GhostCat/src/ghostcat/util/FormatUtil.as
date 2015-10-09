/*
 * Copyright @2009-2012 HappyElements Inc. All rights reserved.
 * Create date: 2012-9-6
 * Michael Qian
 * 钱晓东
 * xiaodong.qian@happyelements.com
 */
package ghostcat.util
{
	
	public class FormatUtil
	{
		/**
		 * 对于输入的字节数做一个格式化，用于显示网络流量，文件尺寸等等
		 * 大于 1K 显示单位为 KB
		 * 大于 1M 显示单位为 MB
		 * 大于 1G 显示单位为 GB
		 * @param bytes 需要格式化的字节数
		 * @param decimal 保留小数位数，10代表1位， 100代表2位...
		 * @return 格式化完成后的字符串
		 *
		 */
		public static function formatBytes(bytes:Number, decimal:uint = 10):String
		{
			if (bytes < 1024) //B
			{
				return int(bytes) + " B";
			}
			else if (bytes < 1024 * 1024) //KB
			{
				return int(bytes / 1024 * decimal) / decimal + " KB";
			}
			else if (bytes < 1024 * 1024 * 1024) //MB
			{
				return int(bytes / (1024 * 1024) * decimal) / decimal + " MB";
			}
			else //GB
			{
				return int(bytes / (1024 * 1024 * 1024) * decimal) / decimal + " GB";
			}
		}
	}
}
