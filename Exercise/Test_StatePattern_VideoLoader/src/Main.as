package {
	
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.display.StageAlign;
	import flash.display.SimpleButton;
	import flash.display.MovieClip;
	import flash.display.LoaderInfo;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.*;
	import flash.text.TextField;
	
	public class Main extends MovieClip {
		private var _bandwidthChecker:BandwidthChecker;
		
		private var _testing:Boolean = true;
		private var _transform:SoundTransform;
		private var _connect:NetConnection;
		private var _stream:NetStream;
		private var _video:Video;
		private var _streamStatus:Array;
		private var _source:String;
		
		private var _isComplete:Boolean;
		private var _isFadeOut:Boolean;
		private var _duration:Number;
		private var _timer:Timer;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _init:Boolean;
		private var _loaded:Boolean;
		
		private var _paused:Boolean;
		private var _playing:Boolean;
		private var _mute:Boolean;
		private var _waiting:Boolean;
		private var _answering:Boolean;
		private var _looping:Boolean;
		private var _activated:Boolean;
		private var _silenced:Boolean;
		
		private var _lastVolume:Number = 1;
		private var _lastPos:Number;
		private var _questions:Array;
		private var _cuePoints:Array;
		private var _next:Object;
		private var _loop:Object;
		private var _select:Object;
		private var _loopCount:int;
		private var _vidParam:String;
		private var _bandWidth:String;
		private var vidSharedObject:SharedObject; 
		
		public function Main() {
			
			this._loopCount = 0;
			
			// Set shortcut for video parameter passed in and default for source.
			this._vidParam = stage.loaderInfo.parameters.video;
			this._source = this._vidParam ? this._vidParam : "final_400.flv";
			
			// Set stage and initialize.
			this.setStage();
			this.init();
			
			// Enable the silence button.
			silenceBtn.addEventListener(MouseEvent.CLICK, onSilenceClick);
			bandwidthBtn.addEventListener(MouseEvent.CLICK, onBandwidthClick);
			bandwidthBtn.visible = false;
			
			// Disable the Silene button
			silenceBtn.visible = false;
			
			// Check the bandwidth.
			this._bandwidthChecker = new BandwidthChecker();
			this._bandwidthChecker.addEventListener(Event.COMPLETE, this.onBWCheckComplete, false, 0, true);
			this._bandwidthChecker.check("http://tools.televoxsites.com/test/sample_image.jpg");
			//trace("Checking bandwidth...");
			
			this._activated = true;
			
			// Activate all buttons.
			//this.activateButtons();
			vidSharedObject = SharedObject.getLocal("superDentistVideo");
		}
		
		private function onSilenceClick(event:MouseEvent):void {
			// Toggle interactions on/off.
			this._silenced = !this._silenced;
			if(this._silenced) {
				for each(var question:MovieClip in this._questions) {
					question.buttonMode = false;
					question.removeEventListener(MouseEvent.ROLL_OVER, onButtonOver);
					question.gotoAndPlay("down25");
				}
				silenceBtn.gotoAndStop(2);
				this._activated = false;
			} else {
				silenceBtn.gotoAndStop(1);
			}
		}
		
		private function onBandwidthClick(event:MouseEvent):void {
			// Toggle interactions on/off.
			this._bandWidth = this._bandWidth == "low" ? "high" : "low";
			if(this._bandWidth == "high") {
				this._source = this._vidParam ? this._vidParam : "final_600.flv";
			} else {
				this._source = this._vidParam ? this._vidParam : "final_400.flv";
			}
			bandwidthBtn.gotoAndStop(this._bandWidth);
			this._lastPos = this._stream.time;
			this.play();
			this.seek(this._lastPos);
		}
		
		
		private function onBWCheckComplete(event:Event):void {
			this._bandwidthChecker.removeEventListener(Event.COMPLETE, this.onBWCheckComplete);
			this._bandWidth = this._bandwidthChecker.getBandwidth();
			bandwidthBtn.gotoAndStop(this._bandWidth);
			
			// Video file path.
			//this._source = "http://thesuperdentists.com/design/3/final_600.flv";
			if(this._bandWidth == "high") {
				this._source = this._vidParam ? this._vidParam : "final_600.flv";
			} else {
				this._source = this._vidParam ? this._vidParam : "final_400.flv";
			}
			//kbtxt.text = bandWidth + " bw";
			// Create new stream for video.
			this.createVideoStream();
		}
		
		
		
		/* Preperation
		**************************************************************/
		private function setStage():void {
			// Set up stage properties.
			stage.showDefaultContextMenu = false;
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.BEST;
			
			
		}
		
		private function init():void {
			// Add all questions
			this._questions = new Array(
				pedo1, pedo2, pedo3, pedo4, pedo5, 
				ortho1, ortho2, ortho3, ortho4, ortho5
			);
			
			this._waiting = true;
			this._next = new Object();
			this._next.time = 0;
			this._loop = new Object();
			this._loop.time = 0;
			
			// Create transform to set volume.
			this._transform = new SoundTransform();
			
			// Set up progress timer.
			this._timer = new Timer(3500);
			this._timer.addEventListener(TimerEvent.TIMER, updateProgress);
			
			this._streamStatus = [];
			
			this._height = 550;
			this._width = 925;
		}
		
		
		
		/* Video Stream Creation
		**************************************************************/
		private function createVideoStream():void {
			// Create new connection.
			this._connect = new NetConnection();
			this._connect.connect(null);
			this._connect.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			this._connect.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			this._connect.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			
			// Create new stream.
			this._stream = new NetStream(this._connect);
			this._stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
			this._stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			this._stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			this._stream.client = this;
			this._stream.bufferTime = 3;
			//this._stream.receiveAudio(true);
			//this._stream.receiveVideo(true);
			
			// Create new video.
			this._video = new Video(this._width, this._height);
			this._video.attachNetStream(this._stream);
			//this._video.smoothing = true;
			this.addChildAt(this._video, 0);
			this.onStageResize(null);
			
			// Preloading now...
			this.play();
			this.pause();
			this.addEventListener(Event.ENTER_FRAME, loaderProgress);
			
			this._timer.start();
		}
		
		
		
		/* Playback Control Functions
		**************************************************************/
		public override function play():void {
			if(this._paused) {
				this._stream.resume();
				this._paused = false;
				this._timer.start();
				return;
			}
			
			this._stream.play(this._source);
			this.setVolume(this._lastVolume * 100);
			this._playing = true;
			this._paused = false;
			this._timer.start();
		}
		
		public function pause():void {
			this._stream.pause();
			this._paused = true;
			this._timer.stop();
		}
		
		public override function stop():void {
			if(!this._playing) return;
			this._stream.pause();
			this._playing = false;
			this._timer.stop();
		}
		
		public function seek(seconds:Number):void {
			if(seconds < this._duration-2 && this._playing) {
				this._lastPos = this._stream.time;
				this._stream.seek(seconds);
				this._stream.resume();
			}
		}
		
		
		
		/*  Volume Control Functions
		=======================================================================*/
		public function setVolume(volume:Number):void {
			this._lastVolume = this._transform.volume = volume/100;
			if(!this._mute) this._stream.soundTransform = this._transform;
		}
		
		public function mute(muted:Boolean = true):void {
			this._mute = muted;
			if(this._mute) {
				this._transform.volume = 0;
				this._stream.soundTransform = this._transform;
			}
			else {
				this._transform.volume = this._lastVolume;
				this._stream.soundTransform = this._transform;
			}
		}
		
		
		
		/* MetaData / CuePoint Handlers
		**************************************************************/
		public function onMetaData(info:Object):void {
			
			// Extract the cue points from the infoObject.
			this._cuePoints = new Array();
			if(this._testing) trace("=====================\nFind Cue Points\n=====================");
			this.findCuePoints( info );
			if(this._testing) trace("\n");
			
			this._duration = info.duration;
			
			if(!isNaN(info.height) && !isNaN(info.width)) {
				this._height = info.height;
				this._width = info.width;
			}
			
			this.onStageResize(null);
		}
		
		
		public function onCuePoint(info:Object):void {
			//trace("running time: " + (getTimer()/1000).toFixed(1) + " seconds");
			//trace("info.name: " + info.name + ",\tinfo.time: " + info.time);
			//trace("next.name: " + this._next.name + ",\tnext.time: " + this._next.time);
			//trace("==========================================");
			if(info.time == this._next.time) {
				// Keep from starting inf loop.
				this._waiting = false;
				return;
			}
			
			// Each cuePoint needs ending Event "loop".
			if(!this._waiting) {
				// Nothing triggered, start looping.
				if(info.name == "loop2") return;
				if(info.type == "Event" && 
					 info.name != "ending") return;
				
				this._answering = false;
				if(this._silenced) {
					this._next = this._loop;
					this.seek(this._next.time);
					return;
				}
				if(!this._activated) {
					this.activateButtons();
				}
				if(this._loopCount == 10) {
					trace(this._loopCount);
					this._next = this._select;
					this.seek(this._next.time);
					this._loopCount = 0;
				} else {
					this._next = this._loop;
					this.seek(this._next.time);
					//this._loopCount++;
				}
			} else {
				this.seek(this._next.time);
				this._answering = true;
				this._waiting = false;
				this._loopCount = 0;
			}
		}
		
		public function onXMPData(info:Object):void {
		}
		
		private function findCuePoints(obj:Object):void {
			var prop:String, val:*;
			for(prop in obj) {
				val = obj[prop];
			
				if(typeof(val) == "object") {
					// Only store "navigation" cuePoints.
					if(val.type == "navigation") {
						// Either the loop or an answer.
						if(val.name == "loop") {
							this._loop = val;
							//this._loop = this._next = val;
						} else {
							if(val.name == "select") {
								this._select = this._next = val;
								//this._select = val;
							}
							this._cuePoints.push(val);
							if(this._testing) {
								if(this._cuePoints.length<10)
								trace("0"+this._cuePoints.length+") name: "+val.name+"\n\t\ttime: "+val.time);
								else trace(this._cuePoints.length+") name: "+val.name+"\n\t\ttime: "+val.time);
							}
						}
					}
					this.findCuePoints(val);
				}
			}
		}
		
		
		
		/*  Error / Status Event Handlers
		=======================================================================*/
		private function onIOError(event:IOErrorEvent):void {
			trace("IOError: " + event.text);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void {
			trace("SecurityError: " + event.text);
		}
		
		private function onAsyncError(event:AsyncErrorEvent):void {
			trace("AsyncError: " + event.text);
		}
		
		private function onNetStatus(event:NetStatusEvent):void {
			if(event.info.code == "NetStream.Seek.InvalidTime") {
				this._stream.seek(this._lastPos);
				this._stream.resume();
			}
			else {
				this.pushStatus(event.info.code);
				this.analyzeStatus();
			}
		}
		
		private function pushStatus(status:String):void {
			this._streamStatus.push(status);
			// Stores ONLY 3 status events at a time.
			while(this._streamStatus.length > 3) this._streamStatus.shift();
		}
		
		private function analyzeStatus():void {
			var stopIdx:Number = this._streamStatus.lastIndexOf("NetStream.Play.Stop");
			var flushIdx:Number = this._streamStatus.lastIndexOf("NetStream.Buffer.Flush");
			var emptyIdx:Number = this._streamStatus.lastIndexOf("NetStream.Buffer.Empty");
			var mediaFinished:Boolean = false;
			
			if(stopIdx > -1 && flushIdx > -1 && emptyIdx > -1) {
				if(flushIdx < stopIdx && stopIdx < emptyIdx) {
					mediaFinished = true;
				}
			}
			else if(flushIdx > -1 && emptyIdx > -1) {
				if(flushIdx < emptyIdx) mediaFinished = true;
			}
			else if(stopIdx > -1 && flushIdx > -1) {
				mediaFinished = true;
			}
			
			if(mediaFinished) {
				//trace("FINISHED_PLAYING");
				while(this._streamStatus.length> 0) this._streamStatus.pop();
				this._next = this._loop;
				this.seek(this._loop.time);
			}
			else if(this._streamStatus[this._streamStatus.length-1] == "NetStream.Play.Start") {
				//trace("STARTED_PLAYING");
				
				if (vidSharedObject.data.initPlayed == "true"){
					this._next = this._loop.time;
					var txtField:TextField = new TextField();
					txtField.text = "Shared Result: "+ vidSharedObject.data.initPlayed;
					this.addChild(txtField);
					
				}else{
					vidSharedObject.data.initPlayed = "true";
					vidSharedObject.flush();
					vidSharedObject.close();
				}
			}
		}
		
		
		
		/*  Stage Resize Handler
		=======================================================================*/
		private function onStageResize(event:Event):void {
			// Resizing of stage requires re-adjustments.
			this._video.height = this._height;
			var ratio:Number = this._video.height / this._height;
			this._video.width = Math.round(this._width * ratio);
			this._video.x = (stage.stageWidth - this._video.width)/2;
			this._video.y = 25;
			
		}
		
		
		
		/*  Video Progress Handlers
		=======================================================================*/
		private function updateProgress(event:TimerEvent):void {
			if(!this._init) {
				// Update the delay to 4 times a second.
				this._timer.delay = 250;
				this._init = true;
			}
			var loaded:Number = this._stream.bytesLoaded;
			var total:Number = this._stream.bytesTotal;
			var pct:Number = Math.round(loaded/total*100);
			
			if(this._duration - this._stream.time <= 1) {
				//this.onVideoComplete();
				this._next = this._loop;
				this.seek(this._loop.time);
			}
			
			// Buffer 8% of the video before playstarting.
			if(pct > 8 && this._paused == true) {
				loader.stop(); //loader movie clips in the Flash IDE
				loader.visible = false;
				this._paused = false;
				this.seek(0);
				
			}
			
			if(!this._loaded) {
				// The last cuepoint is not needed for this.
				for(var i:int=0; i<this._cuePoints.length-1; i++) {
					var question:MovieClip = this._questions[i];
					var cuePercent:Number = Math.round(this._cuePoints[i].time/this._duration * 100);
					
					if(this._cuePoints[i].name == "select"){								
						vidSharedObject.data.initPlayed = true;
						vidSharedObject.flush();
					}
					
					if(cuePercent < pct) {
						if(!question.activated) {
							if(this._testing) {
								if(question.name.length < 6)
								if(cuePercent<10) trace(" %" + cuePercent + " loaded:  " + this._cuePoints[i].name + "Btn Activated");
								else trace("%" + cuePercent + " loaded:  " + this._cuePoints[i].name + "Btn Activated");
								else trace("%" + cuePercent + " loaded: " + this._cuePoints[i].name + "Btn Activated");
							}
							
							
							
							if(!this._answering) {
								question.addEventListener(MouseEvent.ROLL_OVER, onButtonOver);
								question.buttonMode = true;
								if(question.currentFrame <= 5) {
									question.gotoAndPlay("up75");
								}
							}
							question.mouseChildren = false;
							question.activated = true;
						}
						if(i >= this._cuePoints.length-2) {
							this._loaded = true;
						}
					}
				}
			}
		}
		
		private function onVideoComplete():void {
			this._stream.pause();
			this._isComplete = true;
			this._timer.stop();
		}
		
		private function loaderProgress(event:Event):void {
			var loaded:Number = this._stream.bytesLoaded;
			var total:Number = this._stream.bytesTotal;
			var bytesLeft:Number = total - loaded;
			var percent:Number = loaded/total;
			var time:Number = getTimer()/1000;
			var bps:Number = loaded/time;
			var bits:Number = bps/1024;
			var kbps:Number;
			
			if(loaded >= total){
				// Loaded. Do Something.
				percentage.text = "";
				//kbtxt.text = "";
				this.removeEventListener(Event.ENTER_FRAME, loaderProgress);
			} else {
				// Determines how fast the download speed is.
				//kbps = Math.round(bits*10)/10;//  add " Kbps"
				// Update the text fields.
				percentage.text = "%" + String(int(percent * 100));
				//kbtxt.text = kbps + "Kbps";
			}
		}
		
		
		
		/*  Button Click Handler
		=======================================================================*/
		private function activateButtons():void {
			for each(var question:MovieClip in this._questions) {
				if(question.activated) {
					question.addEventListener(MouseEvent.ROLL_OVER, onButtonOver);
					question.buttonMode = true;
					if(question.currentFrame == 15) {
						question.gotoAndPlay("down75");
					} else {
						question.gotoAndPlay("up75");
					}
				}
			}
			this._activated = true;
		}
		
		/*
		seeking forward works great, but reversing takes a second??
		*/
		private function onButtonOver(event:MouseEvent):void {
			var button = event.target;
			button.removeEventListener(MouseEvent.ROLL_OVER, onButtonOver);
			button.addEventListener(MouseEvent.ROLL_OUT, onButtonOut);
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			button.gotoAndPlay("up100");
		}
		
		private function onButtonOut(event:MouseEvent):void {
			var button = event.target;
			button.addEventListener(MouseEvent.ROLL_OVER, onButtonOver);
			button.removeEventListener(MouseEvent.ROLL_OUT, onButtonOut);
			button.removeEventListener(MouseEvent.CLICK, onButtonClick);
			button.gotoAndPlay("down75");
		}
		
		private function onButtonClick(event:MouseEvent):void {
			var index:int;
			switch(event.target.name) {
				case "pedo1" : index = 1; break;
				case "pedo2" : index = 2; break;
				case "pedo3" : index = 3; break;
				case "pedo4" : index = 4; break;
				case "pedo5" : index = 5; break;
				case "ortho1" : index = 6; break;
				case "ortho2" : index = 7; break;
				case "ortho3" : index = 8; break;
				case "ortho4" : index = 9; break;
				case "ortho5" : index = 10; break;
			}
			
			for each(var question:MovieClip in this._questions) {
				question.buttonMode = false;
				if(question != event.target && question.activated) {
					question.removeEventListener(MouseEvent.ROLL_OVER, onButtonOver);
					question.gotoAndPlay("down25");
				} else {
					question.removeEventListener(MouseEvent.ROLL_OUT, onButtonOut);
					question.removeEventListener(MouseEvent.CLICK, onButtonClick);
				}
			}
			this._next = this._cuePoints[index];
			this._activated = false;
			this._answering = true;
			this._waiting = true;
		}
		
		
	}
}