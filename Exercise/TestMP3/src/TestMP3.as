package
{
	import MP3.MP3Parser;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import com.vox.locallog.logManager.LogManager;
	
	public class TestMP3 extends Sprite
	{
		private var url1:String = "../assets/1_CBR_128k_44100.mp3";
		private var url2:String = "../assets/1_VBR_70_44100.mp3";
		private var url3:String = "../assets/1_VBR_70_44100_+2.mp3";
		
		public function TestMP3()
		{
			LogManager.initLog();
			MP3Parser.log = true;
			
			load(url3, testParse);
		}
		
		/**去加载mp3文件*/
		private function load(url:String, callback:Function):void
		{
			var req:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, function(event:Event):void
			{
				loader.removeEventListener(Event.COMPLETE, arguments.callee);
				var data:ByteArray = loader.data as ByteArray;
				trace("=== load complete. length=" + data.length);
				callback(data);
			});
			loader.load(req);
		}
		
		private function testParse(data:ByteArray):void
		{
			var parser:MP3Parser = new MP3Parser(data);
			parser.checkID3 = true;
			parser.checkVBR = true;
			
			var ret:Boolean = parser.validate();
			trace("isMP3: " + ret);
			trace("VBR: " + parser.VBRType);
			
			
			var t:Number = new Date().time;
			MP3Parser.log = false;
			for (var i:int = 0; i < 10000; i++)
			{
				parser = new MP3Parser(data);
				
				parser.validate()
				//ret = parser.validate();
				//if (!ret) { trace("break"); break; }
			}
			trace(new Date().time - t);
		}
	}
}