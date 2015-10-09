package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.text.TextField;
	
	import ghostcat.ui.controls.GText;
	
	public class TestDebug extends Sprite
	{
		public function TestDebug()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(...args):void
		{
			var t:TextField = new TextField();
			addChild(t);
			t.appendText("player is debug: " + Capabilities.isDebugger);
			t.appendText("\n");
			t.appendText("trace: " + testTrace());
			t.appendText("\n");
			t.appendText("catch: " + testCatch());
			t.appendText("\n");
			t.appendText("error: " + testError());
			t.appendText("\n");
			trace(GText);
			t.appendText("trace include:" + ApplicationDomain.currentDomain.hasDefinition("ghostcat.ui.controls.GText"));
			trace(t.text);
			testErrorAlert();
		}
		
		private function testTrace():Boolean
		{
			var result:Boolean = false;
			trace(result=true);
			return result;
		}
		
		public function testCatch():Boolean
		{
			var result:Boolean = false;
			try {
				"fuck"["fuck"];
			} catch (e:Error) {
				result = true;
			}
			return result;
		}
		
		public function testError():Boolean
		{
			var err:Error = new Error();
			return err.getStackTrace() != null;
		}
		
		public function testErrorAlert():void
		{
			"fuck2"["fuck2"];
		}
		
	}
}