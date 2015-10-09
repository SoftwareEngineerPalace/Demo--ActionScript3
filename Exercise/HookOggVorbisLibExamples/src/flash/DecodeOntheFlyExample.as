package  
{//Package
	import cmodule.hookOggVorbisLib.CLibInit;
	import com.jac.ogg.events.OggManagerEvent;
	import com.jac.ogg.OggManager;
	import fl.controls.Button;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class DecodeOntheFlyExample extends MovieClip
	{//DecodeOntheFlyExample Class
	
		//ELEMENTS
		public var playPauseButton:Button;
		public var loadButton:Button;
		//ELEMENTS
	
		private const BYTES_PER_SAMPLE:Number = 8;
		private const NUM_SAMPLES:int = 2048;
		
		private var _isPlaying:Boolean;
		private var _oggBytes:ByteArray;
		private var _fileRef:FileReference;
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _oggManager:OggManager;
		private var _playPosition:int;
		
		//Alchemy Loader object
		private var _loader:CLibInit;
		
		//Alchemy -> AS3 object (our hook to the alchemy methods)
		private var _lib:Object;
		private var _isFullyDecoded:Boolean;
		
		
		public function DecodeOntheFlyExample() 
		{//DecodeOntheFlyExample
			_isPlaying = false;
			_oggBytes = new ByteArray();
			_oggManager = new OggManager();
			_isFullyDecoded = false;
			_playPosition = 0;
			
			//Make sound
			_sound = new Sound();
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSoundData, false, 0, true);
			
			//Setup the alchemy library
			_loader = new CLibInit;
			_lib = _loader.init();
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage, false, 0, true);
		}//DecodeOntheFlyExample
		
		private function handleSoundData(e:SampleDataEvent):void
		{//handleSoundData
			var result:Object;
			var tmpBuffer:ByteArray = new ByteArray();
			result = _oggManager.getSampleData(NUM_SAMPLES, tmpBuffer);
			
			if (tmpBuffer.length < NUM_SAMPLES * BYTES_PER_SAMPLE)
			{//reset
				trace("Rewind");
				//Right now the only way to rewind is reseting the decoder
				_oggManager.initDecoder(_oggBytes);
				result = _oggManager.getSampleData(NUM_SAMPLES, tmpBuffer);
			}//reset
		
			tmpBuffer.position = 0;	
			
			while (tmpBuffer.bytesAvailable)
			{//feed
				//feed data
				e.data.writeFloat(tmpBuffer.readFloat());		//Left Channel
				e.data.writeFloat(tmpBuffer.readFloat());		//Right Channel
			}//feed
			
		}//handleSoundData
		
		private function handleAddedToStage(e:Event):void 
		{//handleAddedToStage
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			
			playPauseButton.addEventListener(MouseEvent.CLICK, handlePlayPauseClick, false, 0, true);
			loadButton.addEventListener(MouseEvent.CLICK, handleLoadClick, false, 0, true);
			
			playPauseButton.enabled = false;
			
		}//handleAddedToStage
		
		private function handlePlayPauseClick(e:MouseEvent):void 
		{//handlePlayPauseClick
			_isPlaying = !_isPlaying;
			if (_isPlaying)
			{//playing
				playPauseButton.label = "Pause";
				_soundChannel = _sound.play();
				_isPlaying = true;
			}//playing
			else
			{//stopped
				playPauseButton.label = "Play";
				_soundChannel.stop();
				_isPlaying = false;
			}//stopped
		}//handlePlayPauseClick
		
		private function handleLoadClick(e:MouseEvent):void 
		{//handleLoadClick
			_fileRef = new FileReference();
			
			if (_isPlaying)
			{//stop
				_soundChannel.stop();
				playPauseButton.label = "Play";
				_isPlaying = false;
			}//stop
			
			_fileRef.addEventListener(Event.SELECT, handleBrowseComplete, false, 0, true);
			_fileRef.browse([new FileFilter("ogg", "*.ogg")]);
			
		}//handleLoadClick
		
		private function handleBrowseComplete(e:Event):void 
		{//handleBrowseComplete
			_fileRef.removeEventListener(Event.SELECT, handleBrowseComplete, false);
			_fileRef.addEventListener(Event.COMPLETE, handleLoadComplete, false, 0, true);
			_fileRef.load();
		}//handleBrowseComplete
		
		private function handleLoadComplete(e:Event):void 
		{//handleLoadComplete
			_fileRef.removeEventListener(Event.COMPLETE, handleLoadComplete);
			
			//Save bytes
			_oggBytes.length = 0;
			_oggBytes.writeBytes(_fileRef.data);
			trace("Load Complete: " + _oggBytes.length);
			_oggBytes.position = 0;
			trace("Init Decoder");
			_oggManager.initDecoder(_oggBytes);
			
			playPauseButton.enabled = true;
			
		}//handleLoadComplete
		
	}//DecodeOntheFlyExample Class

}//Package