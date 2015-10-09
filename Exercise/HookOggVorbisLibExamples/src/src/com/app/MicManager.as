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
{//Package
	import com.app.events.MicManagerEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.media.Microphone;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class MicManager extends EventDispatcher
	{//MicManager Class
	
		private var _recData:ByteArray;
		private var _isRecording:Boolean;
		private var _mic:Microphone;
		private var _micDenied:Boolean;
		
		public function MicManager() 
		{//MicManager
			_isRecording = false;
			_micDenied = false;
			_recData = new ByteArray();
			
			//Setup mic
			_mic = Microphone.getMicrophone();
			if (_mic != null)
			{//wait for ready
				_mic.setLoopBack(false);
				_mic.setUseEchoSuppression(false);
				_mic.rate = 44;
				_mic.addEventListener(StatusEvent.STATUS, handleMicStatus, false, 0, true);
				trace("good mic");
			}//wait for ready
			else
			{//no mic
				trace("no mic");
			}//no mic
			
		}//MicManager
		
		public function toggleRecording():void
		{//toggleRecording
			if (_isRecording)
			{//stop
				stopRecording();
			}//stop
			else
			{//start
				startRecording();
			}//start
		}//toggleRecording
		
		public function startRecording():void
		{//startRecording
			_recData.length = 0;
			_mic.setSilenceLevel(0);
			_mic.addEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData, false, 0, true);
			_isRecording = true;
			dispatchEvent(new Event(Event.CHANGE));
		}//startRecording
		
		public function stopRecording():void
		{//stopRecording
			_isRecording = false;
			_mic.setSilenceLevel(100);
			_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, handleSampleData, false);
			dispatchEvent(new Event(Event.CHANGE));
			dispatchEvent(new MicManagerEvent(MicManagerEvent.NEW_DATA, _recData));
		}//stopRecording
		
		private function handleMicStatus(e:StatusEvent):void 
		{//handleMicStatus
			trace("Got Mic Status: " + e.code);
			
			if (e.code == "Microphone.Muted")
			{//denied
				stopRecording();
			}//denied
			
		}//handleMicStatus
		
		private function handleSampleData(e:SampleDataEvent):void 
		{//handleSampleData
			while (e.data.bytesAvailable)
			{//save data
				//Grab bytes
				var samp:Number = e.data.readFloat();
				
				//convert to stereo
				_recData.writeFloat(samp);	//Left Channel
				_recData.writeFloat(samp);	//Right Channel
				
			}//save data
		}//handleSampleData
		
		public function reset():void
		{//reset
			_recData.length = 0;
		}//reset
		
		public function get recData():ByteArray { return _recData; }
		public function get isRecording():Boolean { return _isRecording; }
		public function get micDenied():Boolean { return _micDenied; }
		
	}//MicManager Class

}//Package