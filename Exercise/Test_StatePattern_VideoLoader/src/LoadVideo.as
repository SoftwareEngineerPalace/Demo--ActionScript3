package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.*;

	public class LoadVideo extends Sprite
	{
		
		private var _vid:Video;
		private var nc:NetConnection;
		private var _ns:NetStream;
	
		private var listener:Object = new Object();	
		private var videoStatus:String;
		private var videoURL:String;
		private var _currentVideoTime:Number;
		private var _loadedPercent:uint;
		private var _startPlayPercent:uint;
			
		public function LoadVideo(videoString:String, width:Number,height:Number)
		{
			videoURL = videoString;
			_vid = new Video(width, height);
			addChild(_vid);
			nc = new NetConnection();
			nc.connect(null);			
			_ns = new NetStream(nc);	
			
			addEvents();
			
		}
		
		private function playVideo():void{
			_vid.smoothing = true;				
			_vid.attachNetStream(_ns);
			//_vid.x = stage.stageWidth - (_vid.width/1.5);//custom positioning of video				
			_ns.play(videoURL);	
			
		}
		
		private function addEvents():void{	
			
			listener.onPlayStatus = function(evt:Object):void {};//prevents some suplerfulous error messages
			listener.onMetaData = function(evt:Object):void {};
			_ns.client = listener;
			_ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			playVideo();
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {			
			videoStatus = event.info.code;
			trace(videoStatus);
			
			switch (videoStatus) {				
				case "NetStream.Play.Start":
					//starts the video as the first inital play through and pauses the video for buffering
					trace("starting");
					_ns.pause();					
				break;
				
				case "NetStream.Buffer.Empty":
					//when Empty is triggered a array value is stored at that byte count	
				break;
			}//end Switch			
			
		}
	
		private function onEnterFrame(e:Event):void{			
			_loadedPercent = (_ns.bytesLoaded/_ns.bytesTotal) * 100;			
			_currentVideoTime = _ns.time;
			
			if(currentPercentLoaded == 100){
				
				//removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		
		
		
		public function get stream():NetStream{			
			return _ns;
		}
		
		public function get video():Video{			
			return _vid;
		}
		
		
		public function get currentTime():Number{			
			return _currentVideoTime;
		}
		
		public function get currentPercentLoaded():Number{			
			return _loadedPercent;
		}
		
		public function set startPlayPercent(value:Number):void{			
			_startPlayPercent = value;
		}
		
		public function get startPlayPercent():Number{			
			return _startPlayPercent;
		}
		
		
	}//end Class
}//end Package