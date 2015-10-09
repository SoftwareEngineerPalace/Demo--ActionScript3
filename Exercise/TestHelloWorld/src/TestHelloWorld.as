package
{
	import com.vox.future.Application;
	import com.vox.future.managers.ContextManager;
	import com.vox.test.net.MessageType;
	import com.vox.test.net.messages.InitInfoMessage;
	import com.vox.test.net.types.response.InitInfoResponse;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class TestHelloWorld extends Application
	{
		override public function get testFlashVars():Object
		{
			return {
				debug:true,
				flashId:'TestHelloWorld',
				domain:'http://localhost:8088',
				imgDomain:'http://localhost:8088'
			}
		}
		
		public function TestHelloWorld()
		{
			if( stage )
			{
				onAddedToStage( );
			}
			else
			{
				this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage ) ;
			}
		}
		
		override public function listCommandDict():Dictionary
		{
			// TODO Auto Generated method stub
			return MessageType.commandDict;
		}
		
		private function onAddedToStage( $evt:Event = null ):void
		{
			this.stage.addEventListener( MouseEvent.CLICK, onStageClick) ;
		}
		
		private function onStageClick( $evt:MouseEvent ):void
		{
			ContextManager.context.dispatchEvent( new InitInfoMessage() ) ;
		}
		
		[CommandResult]
		public function onInitInfoResponse(response:InitInfoResponse, request:InitInfoMessage):void
		{
			trace("返回了数据");
		}
		
		override protected function get version():String
		{
			return CONFIG::VERSION;
		}
	}
}