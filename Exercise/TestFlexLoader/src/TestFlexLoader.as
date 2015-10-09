package
{
	import com.vox.gospel.locallog.logManager.LogManager;
	import com.vox.gospel.locallog.logging.ILogger;
	import com.vox.gospel.locallog.logging.Log;
	import com.vox.gospel.locallog.logging.LogEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	[SWF(width="800",height="600")]
	public class TestFlexLoader extends Sprite
	{
		private var _logger:ILogger;
		
		public function TestFlexLoader()
		{
			addEventListener(Event.ADDED_TO_STAGE, function(event:Event):void
			{
				removeEventListener(event.type, arguments.callee);
				init();
			});
		}
		
		
		private var _logArea:TextField;
		
		private function init():void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			LogManager.initLog();
			
			_logger = Log.getLogger("VoxFlexLoader");
			_logger.addEventListener(LogEvent.LOG, onLogEvent);
			
			var btn:Sprite = new Sprite();
			btn.graphics.beginFill(0xff0000,1);
			btn.graphics.drawRect(0,0,100,20);
			btn.graphics.endFill();
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, loadFlexSWF);
			
			var btn2:Sprite = new Sprite();
			btn2.graphics.beginFill(0x00ff00,1);
			btn2.graphics.drawRect(0,0,60,20);
			btn2.graphics.endFill();
			addChild(btn2);
			btn2.y = 50;
			btn2.addEventListener(MouseEvent.CLICK, exportLog);
			
			_logArea = new TextField();
			addChild(_logArea);
			_logArea.y = 70;
			_logArea.width = 500;
			_logArea.height = 500;
			_logArea.wordWrap = false;
			_logArea.multiline = true;
		}
		
		private function loadFlexSWF(...args):void
		{
			var url:String = "../../TestFlexLoader_content/bin-debug/TestFlexLoader_content.swf";
			var req:URLRequest = new URLRequest();
			req.url = url;
			
			var imgDomain:String = "C:/Users/jishu/Desktop/新建文件夹";
			
			var loader:VoxFlexLoader = new VoxFlexLoader(imgDomain);
			loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
			loader.addEventListener(Event.COMPLETE, onComplete);
			
			loader.load(req);
		}
		
		private function onProgress(event:ProgressEvent):void
		{
			log("--- progress: " + event.bytesLoaded + "/" + event.bytesTotal);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			log("--- io error ---");
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void
		{
			log("--- security error ---");
		}
		
		private function onUncaughtError(event:UncaughtErrorEvent):void
		{
			log("--- uncaught error ---");
		}
		
		private function onComplete(event:Event):void
		{
			log("--- all complete ---");
			
			var ul:VoxFlexLoader = VoxFlexLoader(event.currentTarget);
			var data:ByteArray = ByteArray(ul.data);
			
			var lc:LoaderContext = new LoaderContext();
			lc.checkPolicyFile = false;
			lc.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
			lc.parameters = loaderInfo.parameters;
			
			var loader:Loader = new Loader();
			addChild(loader);
			loader.x = 500;
			loader.loadBytes(ul.data, lc);
		}
		
		private function log(msg:String):void
		{
			//_logArea.appendText(msg);
			_logger.debug(">> " + msg);
		}
		
		private function onLogEvent(event:LogEvent):void
		{
			_logArea.appendText(event.message + "\n");
			_logArea.scrollV = _logArea.numLines;
		}
		
		private function exportLog(...args):void
		{
			try
			{
				var file:FileReference = new FileReference( ) ;
				var logs:String = LogManager.getLifeLogs().join("\n") ;
				file.save( logs , "log.txt" ) ;
			}
			catch(e:Error)
			{
				trace("there is an error when saving local log");
			}
		}
	}
}