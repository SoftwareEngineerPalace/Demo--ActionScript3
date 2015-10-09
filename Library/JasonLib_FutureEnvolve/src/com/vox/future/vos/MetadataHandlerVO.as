package com.vox.future.vos
{
	/**通信消息返回后，调用回调时使用的处理器数据*/
	public class MetadataHandlerVO
	{
		/**监听类型名*/
		public var targetClassName:String ;
		
		/** CommandResult 功能回调的第二个参数类型*/
		public var requestClassName:String ;
		
		/**监听者类型名*/
		public var className:String ;
		
		/**条件字典*/
		public var conditionDict:Object ;
		
		/**方法名*/
		public var methodName:Object ;
		
		/**方法引用字典*/
		public var methodList:Array ;
		
		/**是否具有优先处理权限，默认是false*/
		public var prior:Boolean = false ;
	}
}