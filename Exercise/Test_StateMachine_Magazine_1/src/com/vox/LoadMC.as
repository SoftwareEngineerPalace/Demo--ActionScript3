package com.vox
{
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class LoadMC extends MovieClip 
	{
		private var _targetImg:String;
		private var _loader:Loader;
		private var _tarMC:MovieClip;
		private var _req:URLRequest;
		private var _showTxt:TextField;
		private var _load_mc:loadBarsUI=new loadBarsUI();
		private var CE:CurStateEvent;
		private var _Stage:Stage;
		private var _n:uint;
		
		public function LoadMC(imgPath:String,n:uint):void 
		{
			_n=n;
			_targetImg=imgPath;
			if (getChildByName("loadMC")) {
				removeChild(getChildByName("loadMC"));
			}
			_load_mc.alpha=1;
			_load_mc.name="loadMC";
			_load_mc.enabled=false;
			addChild(_load_mc);
			loadTargetImg(_targetImg);
		}
		
		private function loadTargetImg(img:String):void 
		{
			_loader=new Loader  ;
			_req=new URLRequest  ;
			_req.url=img;
			_loader.load(_req);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,LoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,showError);
		}
		
		private function removeTxt(S:String):void 
		{
			if (this.getChildByName(S)) {
				this.removeChild(this.getChildByName(S));
			}
		}
		
		private function LoadComplete(e:Event):void 
		{
			_load_mc.addEventListener(Event.ENTER_FRAME,setAlphaOut);
			if (e.target.content is MovieClip) {
				e.target.content.alpha=1;
				_tarMC=e.target.content;
			} else {
				_tarMC=new MovieClip();
				_tarMC.alpha=1;
				_tarMC.addChild(e.target.content);
			}
			e.target.removeEventListener(Event.COMPLETE,LoadComplete);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR,showError);
		}
		
		private function setAlphaOut(e:Event):void 
		{
			e.target.alpha-=.1;
			if (e.target.alpha<=0) 
			{
				e.target.removeEventListener(Event.ENTER_FRAME,setAlphaOut);
				if (getChildByName("loadMC")) 
				{
					removeChild(getChildByName("loadMC"));
				}
				dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,_n));
			}
		}
		
		private function showError(e:IOErrorEvent):void 
		{
			dispatchEvent(new CurStateEvent(CurStateEvent.Current_Id,StaticVars.SYSTEM_LOAD_ERROR));
		}
		
		public function get targetMC():MovieClip 
		{
			return _tarMC;
		}
	}
}