package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
		
	public class LoadingState implements IVideoState
	{		
		private var bandwidthChecker:BandwidthChecker;		
		private var bandwidthVideoSize:String;
		private var intervalTimer:Timer = new Timer(1000);
		private var _media:MediaStatePlayer;
		
		public function LoadingState(msObject:MediaStatePlayer)
		{	
			_media = msObject;		
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);					
		}
		
		
		public function applyState():void{			
			checkBandwidth();
		}
	
		private function checkBandwidth():void{
			trace("got video");
			bandwidthChecker = new BandwidthChecker("https://www.baidu.com/img/bd_logo1.png");					
		}		
		
		public function buttonState():void{			
			for each (var button:SimpleButton in _media.buttons){
				button.mouseEnabled = false;
				button.alpha = .25;
			}
		}		
		
		private function setBandwidth(gEvent:GlobalEvent):void{	
			trace("bandwith complete")
			GlobalDispatcher.GetInstance().removeEventListener(GlobalEvent.BANDWIDTH_COMPLETE, setBandwidth);
			bandwidthVideoSize = bandwidthChecker.bandwidth;
			startLoadTimer();
		}
		
		private function startLoadTimer():void{			
			intervalTimer.addEventListener(TimerEvent.TIMER,checkVideo);
			intervalTimer.start();
			
		}		
		
		private function checkVideo(tEvent:TimerEvent):void{	
			trace("check video "+ _media.video.currentPercentLoaded);
			if(_media.video.currentPercentLoaded > _media.video.startPlayPercent){	
				intervalTimer.removeEventListener(TimerEvent.TIMER, checkVideo);
				intervalTimer = null;
				_media.setPlaying();
			}
		}		
	
		
	}//end Class
}//end Package