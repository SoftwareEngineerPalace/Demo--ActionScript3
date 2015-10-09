package com.vox.gospel.rpc.http
{
	import com.vox.gospel.events.IAsyncOverEvent;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.net.URLLoader;
	
	public class HttpRequestOverEvent extends Event implements IAsyncOverEvent {
		static internal const HTTP_REQUEST_OVER:String = "httpRequestOver";
		
		static public const OverStatus_Complete:String = "complete";
		static public const OverStatus_Error:String = "error";
		static public const OverStatus_Timeout:String = "timeout";
		
		
		private var _urlLoader:URLLoader;
		internal var _httpStatusEvent:HTTPStatusEvent;
		
		public function HttpRequestOverEvent(urlLoader:URLLoader) {
			super(HTTP_REQUEST_OVER);
			_urlLoader = urlLoader;
		}
		
		public function get responseData():Object {
			return _urlLoader.data;
		}
		
		public function get httpStatusEvent():HTTPStatusEvent {
			return _httpStatusEvent;
		}
		
		
		internal var _overStatus:String;
		public function get overStatus():String {
			return _overStatus;
		}
		
		internal var _overStatusDetail:String;
		public function get overStatusDetail():String {
			return _overStatusDetail;
		}
		
		public function isComplete():Boolean {
			return _overStatus == OverStatus_Complete;
		}
	}
}
