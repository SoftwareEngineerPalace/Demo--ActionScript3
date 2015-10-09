package com.jason.logtool.pingback.def
{
	public class PingbackErrorCode
	{
		public function PingbackErrorCode()
		{
		}
		
		/**网络*/
		public static const NetworkError:String = "NetworkError";
		/**安全*/
		public static const SecurityError:String = "SecurityError";
		/**超时*/
		public static const Timeout:String = "Timeout";
		/**获取分数*/
		public static const ScoreError :String = "ScoreError";
	}
}