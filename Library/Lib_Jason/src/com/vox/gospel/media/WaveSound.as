package com.vox.gospel.media
{
	import com.vox.gospel.events.CommonAsyncOverEvent;
	import com.vox.gospel.media.mp3.MP3Parser;
	import com.vox.gospel.rpc.http.HttpClient;
	import com.vox.gospel.rpc.http.HttpRequestOverEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class WaveSound extends EventDispatcher
	{
		private var _sound                    : Sound ;
		private var _data                     : Object;
		private var _position                 : uint;
		private var _overEventDispatched      : Boolean;
		private var _timerSampleDataTimeout   : Timer;
		private var _sampleDataEventCount     : int;
		private var _sampleDataEventCountLast : int;
		private var _autoPlayAfterDownload    : Boolean;
		
		private var _isMP3:Boolean = false;
		
		public static var EVENT_DOWNLOAD_OVER:String = 'download_over';
		public static var EVENT_PLAY_OVER:String = 'play_over';
		
		public function WaveSound() 
		{
			_sound = new Sound();
			_timerSampleDataTimeout = new Timer(2000, 0);  //每n秒检查一下声音是否还在播放，如果没在播放就强制停止，防止flash卡死
			_timerSampleDataTimeout.addEventListener(TimerEvent.TIMER, timerSampleDataTimeoutHandler);
		}
		
		public function loadAndPlay(url:String):void
		{
			//trace('WaveSound.loadAndPlay ' + url);
			_autoPlayAfterDownload = true;
			load(url);
		}
		
		public function load(url:String):void 
		{
			//trace('WaveSound.load ' + url);
			_position = 0;
			HttpClient.build(url)
				.setResponseDataTypeBinary()
				.handleHttpRequestOverEvent(function (e:HttpRequestOverEvent):void 
				{
					//trace('WaveSound.load onOver ' + url);
					try 
					{
						var bytes:ByteArray = e.responseData as ByteArray;
						var mp3:MP3Parser = new MP3Parser(bytes);
						_isMP3 = mp3.validate();
						//trace("is mp3: "+_isMP3);
						if(_isMP3)
						{
							if ( _sound && _sound.hasEventListener(SampleDataEvent.SAMPLE_DATA)) {
								_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandlerEx);
							}
							_sound = new Sound();
							_sound.loadCompressedDataFromByteArray(bytes, bytes.bytesAvailable);
						}
						else
						{
							loadWaveData(bytes);
						}
						
						if(bytes.length > 512)
						{
							dispatchEvent(new CommonAsyncOverEvent(EVENT_DOWNLOAD_OVER, true, bytes));
						}
						else
						{
							dispatchEvent(new CommonAsyncOverEvent(EVENT_DOWNLOAD_OVER, false, bytes));
						}
					}
					catch (err:Error)
					{
						dispatchEvent(new CommonAsyncOverEvent(EVENT_DOWNLOAD_OVER, false, bytes));
					}
					
					if (_autoPlayAfterDownload)
					{
						play();
					}
				})
				.doGet();
		}
		
		private var _soundChannel:SoundChannel ;
		public function play():void
		{
			//trace('WaveSound.play');
			if ( _sound.hasEventListener(SampleDataEvent.SAMPLE_DATA))
			{
				stop();
			}
			_overEventDispatched = false;
			if(_isMP3)
			{
				_soundChannel = _sound.play();
				_soundChannel.addEventListener(Event.SOUND_COMPLETE, function(event:Event):void
				{
					_soundChannel.removeEventListener(Event.SOUND_COMPLETE, arguments.callee);
					stop();
				});
			}
			else
			{
				_sampleDataEventCount = 0;
				_sampleDataEventCountLast = 0;
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandlerEx);
				_timerSampleDataTimeout.start();
				
				_soundChannel = _sound.play();
				if(_soundChannel == null) 
				{
					//FIXME: add trace log ... no sound channel?
					//trace('WaveSound.play no sound channel');
					stop();
				}
			}
		}
		
		public function stopSound():void
		{
			if(_soundChannel)
			{
				_soundChannel.stop() ;
			}
		}
		
		private function isMP3(bytes:ByteArray):Boolean
		{
			var temp:ByteArray = new ByteArray();
			// 读取2个字节16位数据
			bytes.position = 0;
			bytes.readBytes(temp, 0, 2);
			bytes.position = 0;
			// 判断这16位数据的前11位是否全是1，如果是则为MP3，否则不是MP3
			var tempUint:uint = temp.readUnsignedShort();
			tempUint = (tempUint & 0xFFE0);
			var isMP3:Boolean = (tempUint == 0xFFE0);
			return isMP3;
		}
		
		private function stop():void 
		{
			//trace('WaveSound.stop');
			
			_timerSampleDataTimeout.stop();
			
			if (_sound.hasEventListener(SampleDataEvent.SAMPLE_DATA))
			{
				_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandlerEx);
			}
			
			if( ! _overEventDispatched) 
			{
				_overEventDispatched = true;
				dispatchEvent(new Event(EVENT_PLAY_OVER));
			}
		}
		
		public function loadWaveData(wavData:ByteArray):Boolean 
		{
			_data = {};
			try 
			{
				_data = WaveCodec.parseWaveData(wavData);
			} 
			catch (e:Error) 
			{
				return false;
			}
			
			if (_data != null && _data['fmt'] != null && _data['data'] != null) 
			{
				//_duration = _data['data']['data'].length; // / _data['fmt']['channel'];
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		private function timerSampleDataTimeoutHandler(e:Event):void
		{
			if(_sampleDataEventCountLast == _sampleDataEventCount) 
			{
				//超过了一定时间还没有触发事件？估计是flash卡的bug了，导致无法继续触发sample data播放声音，只能强制停止
				//trace('WaveSound.timerSampleDataTimeoutHandler timeout, force to stop');
				stop();
			}
			else 
			{
				_sampleDataEventCountLast = _sampleDataEventCount;
			}
		}
		
		private function sampleDataHandlerEx(event:SampleDataEvent):void 
		{
			//trace('WaveSound.sampleDataHandlerEx ... ');
			_sampleDataEventCount ++;
			if (_data && ('data' in _data) && ('data44100' in _data['data']))
				sampleDataHandlerEx2(event);
			else if (_data && ('data' in _data) && ('data' in _data['data']))
				sampleDataHandlerEx1(event);
			else
				stop();
		}
		
		private function sampleDataHandlerEx1(event:SampleDataEvent):void 
		{
			var buf:ByteArray = new ByteArray();
			
			// 这个单位不能太小，需要2048-8192个采样（参见as3官方文档）。总buffer小于2048的时候，Sound类会因为已经播放完，从而不继续请求数据
			var sourceData:Vector.<Number> = _data['data']['data'];
			var sourceConvertChunkSize:uint = 800; // 来源是 8KHz
			var targetConvertChunkSize:uint = 4410; // 目标是flash内置支持的44.1KHz
			var sourceStepDelta:Number = sourceConvertChunkSize / targetConvertChunkSize; // 转换过程中，目标位置每前进1位，来源位置每次增加多少。然后通过上下取整做线性采样
			
			var meetEnd:Boolean = false;
			
			/* if (_data['fmt']['channel'] == 1)  */
			{
				var sourceOffsetBegin:uint = _position;
				var sourceOffsetEnd:uint = Math.min(_position + sourceConvertChunkSize, _data['data']['data'].length);
				var sourceFloatOffset:Number = sourceOffsetBegin;
				
				var targetOffsetBegin:uint = 0;
				var targetOffsetEnd:uint = targetConvertChunkSize;
				var targetOffset:uint = targetOffsetBegin;
				
				var sourcePositionFloor:uint;
				var sourcePositionCeil:uint;
				
				var targetValue:Number;
				
				while (targetOffset < targetOffsetEnd) 
				{
					sourcePositionFloor = Math.floor(sourceFloatOffset);
					sourcePositionCeil = Math.min(sourcePositionFloor + 1, sourceOffsetEnd - 1);
					if (sourcePositionFloor >= sourceOffsetEnd) 
					{
						meetEnd = true;
						break;
					}
					
					targetValue = sourceData[sourcePositionFloor] + (sourceData[sourcePositionCeil] - sourceData[sourcePositionFloor]) * (sourceFloatOffset - sourcePositionFloor);
					
					//双声道
					var _volume:Number = 1;
					buf.writeFloat(targetValue * _volume);
					buf.writeFloat(targetValue * _volume);
					
					sourceFloatOffset += sourceStepDelta;
					targetOffset++;
				}
				_position = sourcePositionFloor + 1;
			}
			/*
			else  {
			// 暂时不支持双声道，有空再说。原理与上面类似，做一个简单的线性采样即可
			var offsetBegin: uint = position;
			//var offsetEnd: uint = position + sourceConvertUnit * 2 ...;
			}
			*/
			
			if (buf.length > 0)
			{
				event.data.writeBytes(buf);
			}
			if (buf.length == 0 || meetEnd) 
			{
				stop();
			}
		}
		
		private function sampleDataHandlerEx2(event:SampleDataEvent):void
		{
			var data44100:ByteArray = _data['data']['data44100'];
			var delta:int = Math.min(data44100.length - data44100.position, 8192 * 2);
			if(delta > 0) {
				event.data.writeBytes(data44100, data44100.position, delta);
				data44100.position += delta;
			}
			
			if(data44100.bytesAvailable <= 0) {
				stop();
			}
		}
		
		public function isDisposed():Boolean 
		{
			return false;
		}
		
		public function dispose():void 
		{
			_data = null;
			_sound = null;
		}
	}
}