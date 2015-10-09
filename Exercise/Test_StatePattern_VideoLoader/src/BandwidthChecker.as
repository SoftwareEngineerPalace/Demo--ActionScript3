package {
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.*;
	
	
	public class BandwidthChecker extends Sprite {
		
		public static const DEFAULT_BANDWIDTH:String = "low";
		public static const DEFAULT_BANDWIDTH_SPEED:Number = 50; // Setting connection threshold speed to 50KBps
		
		private var _bandwidthDetected:String;
		private var bandwidthSpeedDetected:Number;
		private var currentBytesDownloaded:int;
		private var intervalTimer:Timer;
		private var time:Number = 5000;
		private var testFile:String;
		private var loader:Loader;
		private var request:URLRequest;
		
		
		public function BandwidthChecker(testImage:String) {
			testFile = testImage;
			loader = new Loader();
			addListeners();
			loadTestAsset();
			
		}
		
/////////////////////////////////////////////////////////////////////////////
//		PUBLIC METHODS
/////////////////////////////////////////////////////////////////////////////

		private function loadTestAsset():void
		{	
			trace("loadAsset");
			request = new URLRequest(testFile + cacheBlocker());			
			loader.load(request);
		
		}

/////////////////////////////////////////////////////////////////////////////
//		EVENT HANDLERS
/////////////////////////////////////////////////////////////////////////////

		protected function onLoadStart(event:Event):void {	
			trace("on load start");
			intervalTimer = new Timer(time, 1)
			intervalTimer.start();
			intervalTimer.addEventListener(TimerEvent.TIMER,avgDLSpeed);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, currentLoadedBytes);			
		}
		
		private function currentLoadedBytes(e:Event):void{
			currentBytesDownloaded = loader.contentLoaderInfo.bytesLoaded;
		}
	
		
		protected function onLoadError(event:Event):void {
			_bandwidthDetected = DEFAULT_BANDWIDTH;
			bandwidthSpeedDetected = DEFAULT_BANDWIDTH_SPEED;
			DLComplete(event);
		}
		
		private function avgDLSpeed(tEvent:TimerEvent):void{
			trace("avgDLSpeed")
			//this function will run after the timer delay has expired
			//at that time the current bytes downloaded will be calculated against
			//the time to get the average downloaede bytes over that time
			bandwidthSpeedDetected = (loader.contentLoaderInfo.bytesLoaded/1000)/time;
			_bandwidthDetected = (bandwidthSpeedDetected > DEFAULT_BANDWIDTH_SPEED) ? "high" : "low";				
			GlobalDispatcher.GetInstance().dispatchEvent(new GlobalEvent(GlobalEvent.BANDWIDTH_COMPLETE));
		}

		protected function DLComplete(event:Event):void {
			removeListeners();
			intervalTimer = null;
			loader = null;
			request = null;
			testFile = null;
		}
		
		
/////////////////////////////////////////////////////////////////////////////
//		HELPERS
/////////////////////////////////////////////////////////////////////////////
		protected function cacheBlocker():String {
			if ((Capabilities.playerType == "External" || 
					 Capabilities.playerType == "StandAlone")) {
				return "";
			}
			else {
				var date:Date = new Date();
				var time:Number = date.getTime();
				return "?t=" + time.toString();
			}
		}
		
		protected function addListeners():void {
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onLoadStart, false, 0, true);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, DLComplete, false, 0, true);
			
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError, false, 0, true);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError, false, 0, true);
		}
		
		protected function removeListeners():void {
			loader.contentLoaderInfo.removeEventListener(Event.OPEN, onLoadStart);
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, DLComplete);

			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
		}			
		
/////////////////////////////////////////////////////////////////////////////
//		GETTERS
/////////////////////////////////////////////////////////////////////////////
		public function get bandwidth():String {
			return _bandwidthDetected;
		}		
		
		
	}
}
