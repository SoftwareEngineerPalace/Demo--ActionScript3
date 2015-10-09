package
{
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	import mx.events.RSLEvent;
	import mx.preloaders.SparkDownloadProgressBar;
	
	public class TestPreloader extends SparkDownloadProgressBar
	{
		public function TestPreloader()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		private function onCreationComplete(event:Event):void
		{
			trace("=== preloader creation complete ===");
		}
		
		override protected function initProgressHandler(event:Event):void
		{
			trace("== preloader init progress ==");
			super.initProgressHandler(event);
		}
		
		override protected function rslCompleteHandler(event:RSLEvent):void
		{
			trace("=== preloader rsl complete " + event.url.url);
			super.rslCompleteHandler(event);
		}
		
		
		
		
		
	}
}