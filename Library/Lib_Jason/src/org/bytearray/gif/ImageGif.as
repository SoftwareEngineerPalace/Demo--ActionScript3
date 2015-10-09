package org.bytearray.gif
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import ghostcat.ui.controls.GImage;
	
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.player.GIFPlayer;
	
	public class ImageGif extends Sprite
	{
		private var jpgimage:GImage=new GImage();
		private var gifplay:GIFPlayer=new GIFPlayer();
		private var _source:String;

		public function ImageGif(w:Number = 128,h:Number = 128)
		{
			super();
			this.addChild(gifplay);
			this.addChild(jpgimage);
			jpgimage.width = w;
			jpgimage.height = h;
			jpgimage.addEventListener("complete",loadercomplete);
			jpgimage.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			gifplay.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			gifplay.addEventListener(GIFPlayerEvent.COMPLETE, onCompleteGIFLoad);

		}
		public function get source():String
		{
			return _source;
		}
		override public function get width():Number
		{
			return jpgimage.width;
		}
		override public function get height():Number
		{
			return jpgimage.height;
		}
		override public function set width(value:Number):void
		{
			jpgimage.width = value;
		}
		override public function set height(value:Number):void
		{
			jpgimage.height = value;
		}
		public function set source(value:String):void
		{
			_source=value;
			gifplay.stop();
			gifplay.dispose();
			jpgimage.source=null;
			
			var str:String=value.substr(value.length - 3, 3);
			
			this.dispatchEvent
				(new Event("gjlisloading"));
			
			if (str == "jpg" || str == "png" || str=="JPG"||str == "PNG")
			{
				jpgimage.visible = true;
				gifplay.visible = false;
				jpgimage.source = value; 
				return;
			}
			
			if (str == "gif" || str == "GIF")
			{
				
				jpgimage.visible = false;
				gifplay.visible = true;
				gifplay.load ( new URLRequest (value) );
				return;
			}
		}
		
		private function loadercomplete(e:Event):void
		{
			this.dispatchEvent(new Event("gjlloadcompleteEvent"));
		}
		
		private function onCompleteGIFLoad(e:GIFPlayerEvent):void
		{
			this.dispatchEvent(new Event("gjlloadcompleteEvent"));
			gifplay.play();
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			jpgimage.source = "";
			trace("image error");
		}

	}
}