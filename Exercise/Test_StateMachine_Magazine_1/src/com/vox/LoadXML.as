package com.vox 
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	
	public class LoadXML extends Sprite {
		private var _XMLPath:String;
		private var _targetReq:URLRequest;
		private var _targetLoad:URLLoader;
		private var _targetXML:XML=new XML();
		private var _timer:Timer;
		private var _b:Boolean=true;
		private var _load_mc:loadBarsUI=new loadBarsUI();
		private var CE:CurStateEvent;
		private var _n:uint;
		private var _returnArr:Array=new Array();
		public function LoadXML(arr:String,n:uint):void {
			_XMLPath=arr;
			_n=n;
			if (getChildByName("loadMC")) {
				removeChild(getChildByName("loadMC"));
			}
			_load_mc.name="loadMC";
			addChild(_load_mc);
			_load_mc.alpha=1;
			_load_mc.enabled=false;
			timerXML();
		}
		private function timerXML():void {
			_timer=new Timer(200,100);
			_timer.addEventListener(TimerEvent.TIMER,handTimer);
			_timer.start();
		}
		private function handTimer(e:TimerEvent):void {
			if (_b) {
				getXML();
			} else {
				e.target.reset();
				e.target.stop();
				e.target.removeEventListener(TimerEvent.TIMER,handTimer);
			}
		}
		private function getXML():void {
			_targetReq=new URLRequest();
			_targetReq.url=_XMLPath;
			_targetReq.method="post";
			_targetLoad=new URLLoader();
			_targetLoad.load(_targetReq);
			_targetLoad.addEventListener(Event.COMPLETE,xmlComplete);
			_targetLoad.addEventListener(IOErrorEvent.IO_ERROR,xmlError);
		}
		private function setAlphaOut(e:Event):void {
			e.target.alpha-=.05;
			if (e.target.alpha<=0) {
				e.target.removeEventListener(Event.ENTER_FRAME,setAlphaOut);
				if (getChildByName("loadMC")) {
					removeChild(getChildByName("loadMC"));
				}
				dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_n));
			}
		}
		private function xmlComplete(e:Event):void {
			_load_mc.addEventListener(Event.ENTER_FRAME,setAlphaOut);
			_targetXML=XML(e.target.data);
			_b=false;
			e.target.removeEventListener(Event.COMPLETE,xmlComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,xmlError);
			AnalysisXML(_targetXML);
		}
		
		private function xmlError(e:IOErrorEvent):void {
			dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,StaticVars.SYSTEM_LOAD_ERROR));
		}
		
		private function AnalysisXML(xm:XML):void
		{
			var nodes:uint = xm.children().length();
			for (var i:uint=0; i<nodes; i++) 
			{
				_returnArr[i]=xm.children()[i].split("|");
			}
		}
		public function get backArray():Array {
			return _returnArr;
		}
	}
}