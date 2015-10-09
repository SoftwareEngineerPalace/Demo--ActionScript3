package com.vox
{
	/**
	 * @author yalewu
	 */
	//系统状态类。
	public class StaticVars
	{
		//全局静态淡入变量。
		public static  const SYSTEM_ALPHA_IN:Number = .02;
		public static  const SYSTEM_ALPHA_OUT:Number =.02;
		public static  const SYSTEM_FRAME_RATE:uint=30;
		//加载错误代码
		public static  const SYSTEM_LOAD_ERROR:uint=100;
		//重置位置时对象中心点的位置
		public static  const SYSTEM_OBJ_LEFT_TOP:uint=0;
		public static  const SYSTEM_OBJ_MIDDLE_MIDDLE:uint=1;
		public static  const SYSTEM_OBJ_LEFT_MIDDLE:uint=2;
		public static  const SYSTEM_TITLE:String="深圳市城市设计公众参与平台";
		public static  const SYSTEM_BUTTON_ARRAY:Array=new Array("s1","s2","s3","s4");
		public static  const SYSTEM_LOADSWF_ARRAY:Array=new Array([0,"regAndLogin.swf"],"s2","s3","s4");
	}
}