package com.jason.logtool.pingback.def
{
	public class PingbackOperate
	{
		public function PingbackOperate()
		{
		}
		
		/**加载SWF*/
		public static const LoadSWF:String = "LoadSWF";
		/**在加载flash之前记录*/
		public static const LoadStart:String = "LoadStart";
		/**在加载flash成功之后记录*/
		public static const LoadComplete:String = "LoadComplete";
		/**在加载flash失败的记录*/
		public static const LoadFailed:String = "LoadFailed";
		/**在加载flash过程20秒无数据*/
		public static const LoadTimeout:String = "LoadTimeout";
		/**Flash游戏 运行入口*/
		public static const GameStart:String = "GameStart";
		/**Flash游戏 获取作业内容错误*/
		public static const GameData:String = "GameData";
		/**Flash游戏 内部语音引擎加载音频*/
		public static const LoadWave:String = "LoadWave";
		/**Flash游戏 内部语音引擎打分*/
		public static const Score:String = "Score";
		/**Flash游戏 做完游戏*/
		public static const GameEnd:String = "GameEnd";
		/**Flash游戏 上传结果*/
		public static const UploadResult:String = "UploadResult";
		
	}
}