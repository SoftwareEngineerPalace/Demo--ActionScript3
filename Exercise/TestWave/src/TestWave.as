package
{
	import com.greensock.loading.BinaryDataLoader;
	import com.langkoo.engine.WaveSound;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import ghostcat.ui.controls.GButton;
	
	[SWF(width="400",height="300")]
	public class TestWave extends Sprite
	{
		private var _text:TextField;
		private var _btnLoad:GButton;
		
		private var _data:ByteArray;
		private var _wave:WaveSound;
		
		public function TestWave()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(event:*=null):void
		{
			_text = new TextField();
			_text.x = 150;
			_text.y = 10;
			_text.width = 200;
			_text.height = 200;
			addChild(_text);
			_text.text = "";
			
			_btnLoad = new GButton();
			addChild(_btnLoad);
			_btnLoad.x = 10;
			_btnLoad.y = 10;
			_btnLoad.label = "1.wav";
			_btnLoad.addEventListener(MouseEvent.CLICK, onClickLoad);
			
			_btnLoad.visible = true;
		}
		
		private var _loader:BinaryDataLoader;
		
		private function onClickLoad(e:*):void
		{
			_btnLoad.visible = false;
			
			_text.text = "加载";
			
			if (_wave) _wave.stop();
			_wave = null;
			
			_loader = new BinaryDataLoader("./1.wav", {onComplete:onComplete, onError:onError});
			_loader.autoDispose = false;
			_loader.load();
		}
		
		private function onComplete(e:*):void
		{
			_text.appendText("\n已加载");
			
			setTimeout(function():void
			{
				parse(_loader.content as ByteArray);
			}, 50);
		}
		
		private function onError(e:*):void
		{
			_text.appendText("\n加载失败");
			
			_loader = null;
			_btnLoad.visible = true;
		}
			
		private function parse($data:ByteArray):void
		{
			_wave = null;
			var wave:WaveSound = new WaveSound();
			wave.addEventListener(WaveSound.LOAD_COMPLETE, function(e:*):void
			{
				_text.appendText("\n转换成功");
				_loader = null;
				_wave = wave;
				_btnLoad.visible = true;
				
				startPlay();
			});
			wave.addEventListener(WaveSound.FORMAT_ERROR, function(e:*):void
			{
				_text.appendText("\n转换失败");
				_loader = null;
				_btnLoad.visible = true;
			});
			wave.loadWavData($data);
		}
		
		private function startPlay():void
		{
			if (!_wave) return;
			
			_text.appendText("\n播放中");
			_wave.addEventListener(WaveSound.SOUND_COMPLETE, function(e:*):void
			{
				_text.appendText("\n已停止");
				_wave = null;
			});
			_wave.play();
		}
		
	}
}