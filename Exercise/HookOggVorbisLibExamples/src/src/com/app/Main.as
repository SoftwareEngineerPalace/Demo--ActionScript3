/*
Copyright (c)2011 Hook L.L.C

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package src.com.app
{//package
	import com.app.DebugViewer;
	import com.app.events.FileManagerEvent;
	import com.app.events.MicManagerEvent;
	import com.app.FileManager;
	import com.app.MicManager;
	import com.app.PlaybackManager;
	import com.jac.ogg.adobe.audio.format.events.WAVWriterEvent;
	import com.jac.ogg.events.OggManagerEvent;
	import com.jac.ogg.OggComments;
	import com.jac.ogg.OggLibVersionInfo;
	import com.jac.ogg.OggManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	
	[SWF(backgroundColor="#333333", frameRate="30", width="550", height="430")]
	 
	public class Main extends Sprite 
	{//Main Class
	
		private var _view:MainView;
		private var _micManager:MicManager;
		private var _playbackManager:PlaybackManager;
		private var _fileManager:FileManager;
		private var _dv:DebugViewer;
		private var _oggManager:OggManager;
		private var _startTime:Number;
		private var _wavStartTime:Number;
		private var _vorbisStartTime:Number;
		
		public function Main():void 
		{//Main
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}//Main
		
		/**
		 * Sets up the views and event listeners.  Creates instances of MicManager, PlaybackManager, FileManger and OggManager
		 * @param	e
		 */
		private function init(e:Event = null):void 
		{//init
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			_micManager = new MicManager();
			_playbackManager = new PlaybackManager(_micManager);
			_fileManager = new FileManager(_playbackManager);
			_oggManager = new OggManager();
			
			//Example of how to use the OggLibVersionInfo
			var info:OggLibVersionInfo = _oggManager.oggLibVersionInfo;
			
			//views
			_view = new MainView();
			_dv = new DebugViewer(_view.debugText, _view.debugTextScrollBar);
			
			//Show view
			addChild(_view);
			_view.x = 21;
			_view.y = 9;
			
			//Setup buttons
			_view.playPauseButton.enabled = false;
			_view.encodeButton.enabled = false;
			_view.saveButton.enabled = false;
			
			//Listen for events
			_micManager.addEventListener(Event.CHANGE, handleMicManagerChange, false, 0, true);
			_playbackManager.addEventListener(Event.CHANGE, handlePlaybackChange, false, 0, true);
			
			//Ogg Manager Events
			_oggManager.addEventListener(OggManagerEvent.ENCODE_BEGIN, handleEncodeBegin, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.ENCODE_PROGRESS, handleEncodeProgress, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.ENCODE_COMPLETE, handleEncodeComplete, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.ENCODE_CANCEL, handleEncodeCancel, false, 0, true);
			
			_oggManager.addEventListener(OggManagerEvent.WAV_ENCODE_BEGIN, handleWavEncodeBegin, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.WAV_ENCODE_COMPLETE, handleWavEncodeComplete, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.WAV_ENCODE_CANCEL, handleWavEncodeCancel, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.WAV_ENCODE_PROGRESS, handleWavEncodeProgress, false, 0, true);
			
			_oggManager.addEventListener(OggManagerEvent.DECODE_BEGIN, handleDecodeBegin, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.DECODE_PROGRESS, handleDecodeProgress, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.DECODE_COMPLETE, handleDecodeComplete, false, 0, true);
			_oggManager.addEventListener(OggManagerEvent.DECODE_CANCEL, handleDecodeCancel, false, 0, true);
			
			//View\UI Events
			_view.recButton.addEventListener(MouseEvent.CLICK, handleRecClick, false, 0, true);
			_view.playPauseButton.addEventListener(MouseEvent.CLICK, handlePlayPauseClick, false, 0, true);
			_view.encodeButton.addEventListener(MouseEvent.CLICK, handleEncodeClick, false, 0, true);
			_view.saveButton.addEventListener(MouseEvent.CLICK, handleSaveClick, false, 0, true);
			_view.loadButton.addEventListener(MouseEvent.CLICK, handleLoadClick, false, 0, true);
			_view.notifyProgressCheckbox.addEventListener(Event.CHANGE, handleProgressCheckboxChange, false, 0, true);
			_view.cancelButton.addEventListener(MouseEvent.CLICK, handleCancelClick, false, 0, true);
			
			_dv.out("Click 'Record' to record a new sound, or 'Load' to decode an .ogg audio file from your computer");
		}//init
		
		/****** ENCODING ******/
		private function handleEncodeClick(e:MouseEvent):void 
		{//handleEncodeClick
			var oggComments:OggComments = new OggComments();
			
			oggComments.title = _view.titleText.text;
			oggComments.album = _view.albumText.text;
			oggComments.artist = _view.artistText.text;
			
			if (_playbackManager.isPlaying)
			{//stop
				_playbackManager.stopPlay();
			}//stop
			
			_dv.out("Starting Encode...");
			_dv.out("Encode Quality: " + _view.encodeQualityStepper.value);
			_dv.out("Encode Loops Per Yield: " + int(_view.encodeLoopsPerYieldStepper.value));
			
			//handle UI
			_view.playPauseButton.enabled = false;
			_view.loadButton.enabled = false;
			_view.encodeButton.enabled = false;
			
			_startTime = getTimer();
			_oggManager.encode(_playbackManager.playBackBytes, oggComments, _view.encodeQualityStepper.value, 10, int(_view.encodeLoopsPerYieldStepper.value), _view.notifyProgressCheckbox.selected);
		}//handleEncodeClick
		
		private function handleEncodeComplete(e:OggManagerEvent):void 
		{//handleEncodeComplete
			_dv.out("Ogg Vorbis Encode Complete: " + (Math.round((getTimer() - _vorbisStartTime)/1000) + " second(s)"));
			_dv.out("Total Encode Time: " + (Math.round((getTimer() - _startTime)/1000) + " second(s)"));
			
			if (_oggManager.encodedBytes && _oggManager.encodedBytes.length > 0)
			{//update ui
				_view.saveButton.enabled = true;
			}//update ui
			
			_view.playPauseButton.enabled = true;
			_view.loadButton.enabled = true;
			_view.encodeButton.enabled = true;
			
		}//handleEncodeComplete
		
		private function handleEncodeBegin(e:OggManagerEvent):void 
		{//handleEncodeBegin
			_dv.out("Ogg Vorbis Encode Start...");
			_vorbisStartTime = getTimer();
		}//handleEncodeBegin
		
		private function handleEncodeProgress(e:OggManagerEvent):void 
		{//handleEncodeProgress
			_dv.out("Progress: " + e.data);
		}//handleEncodeProgress
		
		private function handleWavEncodeCancel(e:OggManagerEvent):void 
		{//handleWavEncodeCancel
			_dv.out("Canceled WAV encoding");
		}//handleWavEncodeCancel
		
		private function handleWavEncodeComplete(e:OggManagerEvent):void 
		{//handleWavEncodeComplete
			_dv.out("WAV encoding completed: " + (Math.round((getTimer() - _wavStartTime)/1000)) + " second(s)");
		}//handleWavEncodeComplete
		
		private function handleWavEncodeBegin(e:OggManagerEvent):void 
		{//handleWavEncodeBegin
			_dv.out("WAV encoding started...");
			_wavStartTime = getTimer();
		}//handleWavEncodeBeing
		
		private function handleWavEncodeProgress(e:OggManagerEvent):void 
		{//handleWavEncodeProgress
			_dv.out("WAV Progress: " + e.data);
		}//handleWavEncodeProgress
		
		
		/******* DECODING *******/
		private function handleDecodeBegin(e:OggManagerEvent):void 
		{//handleDecodeBegin
			_startTime = getTimer();
			_dv.out("Starting Ogg Vorbis Decode...");
		}//handleDecodeBegin
		
		private function doDecode($oggBytes:ByteArray):void
		{//doDecode
			trace("File Loaded: " + $oggBytes.length);
			
			_view.saveButton.enabled = false;
			_view.encodeButton.enabled = false;
			_view.playPauseButton.enabled = false;
			_view.loadButton.enabled = false;
			
			_dv.out("Bytes Per Loop: " + int(_view.decodeBytesPerLoopStepper.value));
			_dv.out("Decode Delay Per Loop: " + int(_view.decodeDelayPerLoopStepper.value));
			_oggManager.decode($oggBytes, int(_view.decodeBytesPerLoopStepper.value), int(_view.decodeDelayPerLoopStepper.value), _view.notifyProgressCheckbox.selected);
		}//doDecode
		
		private function handleDecodeComplete(e:OggManagerEvent):void 
		{//handleDecodeComplete
			_dv.out("Decode Complete: " + (Math.round((getTimer() - _startTime)/1000) + " second(s)"));
			_playbackManager.loadBytes(_oggManager.decodedBytes);
			
			//update text fields
			_view.titleText.text = _oggManager.oggComments.title;
			_view.albumText.text = _oggManager.oggComments.album;
			_view.artistText.text = _oggManager.oggComments.artist;
			
			_view.loadButton.enabled = true;
			
		}//handleDecodeComplete
		
		private function handleDecodeProgress(e:OggManagerEvent):void 
		{//handleDecodeProgress
			_dv.out("Decode Progress: " + e.data);
		}//handleDecodeProgress
		
		
		
		/****** FILE MANAGEMENT *******/
		private function handleLoadClick(e:MouseEvent):void 
		{//handleLoadClick
			_fileManager.addEventListener(FileManagerEvent.LOAD_COMPLETE, handleFileLoaded, false, 0, true);
			_fileManager.load();
		}//handleLoadClick
		
		private function handleFileLoaded(e:FileManagerEvent):void 
		{//handleFileLoaded
			_fileManager.removeEventListener(FileManagerEvent.LOAD_COMPLETE, handleFileLoaded, false);
			doDecode(ByteArray(e.data));
		}//handleFileLoaded
		
		private function handleSaveClick(e:MouseEvent):void 
		{//handleSaveClick
			_fileManager.save(_oggManager.encodedBytes);
		}//handleSaveClick
		
		
		
		
		
		/******* UI MANAGEMENT *******/
		private function handlePlayPauseClick(e:MouseEvent):void 
		{//handlePlayPauseClick
			_playbackManager.togglePlay();
		}//handlePlayPauseClick
		
		private function handleRecClick(e:MouseEvent):void 
		{//handleRecClick
			_micManager.toggleRecording();
			
			if (_micManager.isRecording)
			{//disable
				_view.loadButton.enabled = false;
				_view.playPauseButton.enabled = false;
				_view.encodeButton.enabled = false;
				_view.saveButton.enabled = false;
				
				if (_playbackManager.isPlaying)
				{//stop
					_playbackManager.stopPlay();
				}//stop
			}//disable
			else
			{//enable
				_dv.out("Recording Stopped");
				_view.loadButton.enabled = true;
			}//enable
			
		}//handleRecClick
		
		private function handlePlaybackChange(e:Event):void 
		{//handlePlaybackChange
			if (_playbackManager.isPlaying)
			{//update play button status
				_view.playPauseButton.label = "Stop";
			}//update play button status
			else
			{//update play button status
				_view.playPauseButton.label = "Play";
			}//update play button status
			
			if (_playbackManager.newBytes)
			{//new bytes
				_dv.out("New Bytes Loaded");
			}//new bytes
			
			if (_playbackManager.playBackBytes && _playbackManager.playBackBytes.length > 0)
			{//we have bytes to work with
				_view.playPauseButton.enabled = true;
				_view.encodeButton.enabled = true;
			}//we have bytes to work with
			else
			{//no bytes
				_view.playPauseButton.enabled = false;
				_view.encodeButton.enabled = false;
				_view.saveButton.enabled = false;
			}//no bytes
			
		}//handlePlaybackChange
		
		private function handleMicManagerChange(e:Event):void 
		{//handleMicManagerChange
			if (_micManager.isRecording)
			{//update label
				_view.recButton.label = "Stop Recording";
				_dv.out("Started Recording");
			}//update label
			else
			{//update label
				_view.recButton.label = "Start Recording";
				_dv.out("Stopped Recording");
			}//update label
		}//handleMicManagerChange
		
		private function handleCancelClick(e:MouseEvent):void 
		{//handleCancelClick
			if (_oggManager.isBusy)
			{//cancel
				_dv.out("Cancel...");
				_oggManager.cancel();
			}//cancel
		}//handleCancelClick
		
		private function handleEncodeCancel(e:OggManagerEvent):void 
		{//handleEncodeCancel
			_dv.out("Encoding Canceled");
			_view.saveButton.enabled = false;
		}//handleEncodeCancel
		
		private function handleDecodeCancel(e:OggManagerEvent):void 
		{//handleDecodeCancel
			_dv.out("Decoding Canceled");
			_view.playPauseButton.enabled = false;
			_view.encodeButton.enabled = false;
			
		}//handleDecodeCancel
		
		private function handleProgressCheckboxChange(e:Event):void 
		{//handleProgressCheckboxChange
			_oggManager.progressNotifications = _view.notifyProgressCheckbox.selected;
		}//handleProgressCheckboxChange
		
	}//Main Class
	
}