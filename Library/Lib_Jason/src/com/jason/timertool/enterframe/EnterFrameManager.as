package  com.jason.timertool.enterframe
{
	import com.jason.timertool.enterframe.IEnterFrame;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author 赵保
	 * 描述：全局timer管理类，在游戏初始化的时候调用bindFrameEvent传入stage
	 */
	public class EnterFrameManager
	{
		private static var list   :ArrayList = new ArrayList() ;
		private static var index  :int = 0;
		
		/**设置全局的enterFrame事件*/
		public static function bindFrameEvent( $stage:Stage ):void
		{ 
			$stage.addEventListener( Event.ENTER_FRAME,onEnterFrame ) ;
		} 
		
		/**enterFrame事件 */
		private static function onEnterFrame( $evt:Event ): void
		{ 
			var len:int = list.size();
			for(var i:int=0 ; i < len ; i++ )
			{
				var ief:IEnterFrame = list.get(i) as IEnterFrame ;
				if(ief != null)
				{
					ief.running();
				}
			}
		}
		
		/**添加对象*/
		public static function addEnterFrame( $obj:IEnterFrame):void
		{
			if( list.contains( $obj ) )
			{
				return ;
			}
			else
			{
				list.append( $obj ) ;
			}
		}
		
		/**移除对象*/
		public static function removeEnterFrame( $obj:IEnterFrame):void
		{
			if( list.contains( $obj ) )
			{
				list.remove( $obj ) ;
			}
		}
	}
}