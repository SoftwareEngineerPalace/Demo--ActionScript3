package com.vox.gospel.rpc.http
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	
	public class HttpClient extends EventDispatcher {
		
		protected var urlLoader:URLLoader = new URLLoader();
		protected var urlRequest:URLRequest = new URLRequest();
		protected var maxRequestCountWithRetry:int = 1;
		protected var currentRequestCount:int = 0;
		protected var timeout:int = 10 * 1000;
		protected var isTimeout:Boolean;
		protected var timerTimeout : Timer;
		
		protected var clientIndex:int;
		protected var httpRequestOverEvent:HttpRequestOverEvent = null;
		
		static protected var clientSequenceNumber:int;
		static protected var cachedClients:Object = {};  //防止没有引用的对象被gc掉
		
		protected function dispatchHttpRequestOverEvent(overStatus:String, overStatusDetail:String = null):void {
			if (httpRequestOverEvent == null) return;
			
			trace('HttpClient ' + urlRequest.url + ' over: ' + overStatus + ', status: ' + httpRequestOverEvent.httpStatusEvent);
			timerTimeout.stop();
			
			httpRequestOverEvent._overStatus = overStatus;
			httpRequestOverEvent._overStatusDetail = overStatusDetail;
			dispatchEvent(httpRequestOverEvent);
			httpRequestOverEvent = null;
			urlLoader = null;
			urlRequest = null;
			delete cachedClients[clientIndex];
		}
		
		public function handleHttpRequestOverEvent(listener:Function):HttpClient {
			addEventListener(HttpRequestOverEvent.HTTP_REQUEST_OVER, listener);
			return this;
		}
		
		
		protected function preRequestInit():void {
			
			httpRequestOverEvent = new HttpRequestOverEvent(urlLoader);
			
			urlLoader.addEventListener(Event.COMPLETE, function (e:Event):void {
				if (isTimeout) return;
				trace('HttpClient ' + urlRequest.url + ' complete');
				dispatchHttpRequestOverEvent(HttpRequestOverEvent.OverStatus_Complete);
			});
			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
				if (isTimeout) return;
				trace('HttpClient ' + urlRequest.url + ' io error');
				dispatchHttpRequestOverEvent(HttpRequestOverEvent.OverStatus_Error, e.text);
			});
			
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function (e:SecurityErrorEvent):void {
				if (isTimeout) return;
				trace('HttpClient ' + urlRequest.url + ' security error');
				dispatchHttpRequestOverEvent(HttpRequestOverEvent.OverStatus_Error, e.text);
			});
			
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function (e:HTTPStatusEvent):void {
				if (isTimeout) return;
				httpRequestOverEvent._httpStatusEvent = e;
			});
		}
		
		static public function build(url:String = null):HttpClient {
			var hc:HttpClient = new HttpClient();
			if (url != null)
				hc.setUrl(url);
			
			hc.clientIndex = clientSequenceNumber;
			cachedClients[hc.clientIndex] = hc;
			clientSequenceNumber++;
			return hc;
		}
		
		public function setUrl(s:String):HttpClient {
			urlRequest.url = s;
			return this;
		}
		
		public function setQueryParams(m:Object):HttpClient {
			var uv:URLVariables = new URLVariables();
			for (var k:String in m) {
				uv[k] = m[k];
			}
			var url:String = urlRequest.url;
			if (url == null) url = "";
			urlRequest.url = url + (((url.indexOf('?') == -1)) ? '?' : '&') + uv.toString();
			return this;
		}
		
		public function setRequestData(o:Object):HttpClient {
			urlRequest.data = o;
			return this;
		}
		
		public function setResponseDataTypeBinary():HttpClient {
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			return this;
		}
		
		public function setRequestContentType(s:String):HttpClient {
			urlRequest.contentType = s;
			return this;
		}
		
		public function setMaxRequestCountWithRetry(n:int):HttpClient {
			maxRequestCountWithRetry = n;
			return this;
		}
		
		public function setMultiPartFormData(form:HttpMultiPartFormData):HttpClient {
			var header:URLRequestHeader = new URLRequestHeader("Content-Type", "multipart/form-data; boundary=" + form.Boundary);
			urlRequest.requestHeaders.push(header);
			urlRequest.data = form.GetFormData();
			return this;
		}
		
		private var timerRetry : Timer;
		
		private function timeoutHandler(e:Event) : void {
			isTimeout = true;
			try {
				urlLoader.close();
			}
			catch (e:Error) {
			}
			
			trace('HttpClient request ' + urlRequest.url + ' ' + currentRequestCount + ' timeout');
			if (currentRequestCount >= maxRequestCountWithRetry) {
				// still timeout, failed.
				dispatchHttpRequestOverEvent(HttpRequestOverEvent.OverStatus_Timeout);
			}
			else {
				timerRetry = new Timer(500, 1);
				timerRetry.addEventListener(TimerEvent.TIMER, function(e:Event) : void{
					doRequest();
				});
				timerRetry.start();
			}
		}
		
		public function setTimeoutMs(n : uint) : HttpClient {
			timeout = n;
			return this;
		}
		
		protected function doRequest():void {
			currentRequestCount++;
			isTimeout = false;
			timerTimeout = new Timer(timeout, 1);
			timerTimeout.addEventListener(TimerEvent.TIMER, timeoutHandler);
			timerTimeout.start();
			
			try {
				urlLoader.load(urlRequest)
			}
			catch (e:Error) {
				dispatchHttpRequestOverEvent(HttpRequestOverEvent.OverStatus_Error, e.message);
			}
		}
		
		public function doGet():void {
			urlRequest.method = URLRequestMethod.GET;
			preRequestInit();
			doRequest();
		}
		
		public function doPost():void {
			urlRequest.method = URLRequestMethod.POST;
			preRequestInit();
			doRequest();
		}
	}
}
