package com.vox.gospel.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import ghostcat.display.GBase;
	
	/**
	 * 
	 * @author Wangyu
	 * 
	 */
	public class GLatex extends GBase
	{
		protected var _latex:String;
		protected var img:Bitmap = new Bitmap();
		
		protected var _width:int = 100;
		protected var _height:int = 100;
		protected var _color:uint;
		protected var _textSize:int = 12;
		protected var _currentDensity:int;
		
		protected var _horizontalAlign:String = ALIGN_LEFT;
		protected var _verticalAlign:String = ALIGN_TOP;
		
		protected var _autoSize:int = AUTOSIZE_WIDTH | AUTOSIZE_RELOAD;
		
		private var _loadUtilHandler:ILoadUtilHandler;
		
		public static const ALIGN_LEFT:String = TextFormatAlign.LEFT;
		public static const ALIGN_RIGHT:String = TextFormatAlign.RIGHT;
		public static const ALIGN_TOP:String = "top";
		public static const ALIGN_BOTTOM:String = "bottom";
		public static const ALIGN_CENTER:String = TextFormatAlign.CENTER;
		
		private static var _imgDomain:String = "";
		
		public function GLatex(skin:*=null)
		{
			super(skin, true);
			this.addChild(img);
		}
		
		/**
		 *公式的水平对齐。接受 ALIGN_LEFT、ALIGN_RIGHT、ALIGN_CENTER。
		 * <br>任何其他值被视为 ALIGN_LEFT。
		 * @return 
		 * 
		 */
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void
		{
			if(ALIGN_CENTER != value && ALIGN_RIGHT != value )
				value = ALIGN_LEFT;
			_horizontalAlign = value;
			setTextSize();
		}
		
		/**
		 *公式的垂直对齐。接受 ALIGN_TOP、ALIGN_BOTTOM、ALIGN_CENTER。
		 * <br>任何其他值被视为 ALIGN_TOP。
		 * @return 
		 * 
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void
		{
			if(ALIGN_CENTER != value && ALIGN_BOTTOM != value )
				value = ALIGN_TOP;
			_verticalAlign = value;
			setTextSize();
		}

		/**
		 *设置文字颜色 
		 * @return 
		 * 
		 */
		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			setColor();
		}

		/**
		 *指定首选字号。如果不指定自动缩放，图像将以该字号呈现。<br>如果未指定 AUTOSIZE_FULL，则图像的最大字号为该值。
		 * @return 
		 * 
		 */
		public function get textSize():int
		{
			return _textSize;
		}

		public function set textSize(value:int):void
		{
			_textSize = value;
			reload(); 
		}

		/**
		 * 指定是否支持自动缩放
		 * @return 
		 * 
		 */
		public function get autoSize():int
		{
			return _autoSize;
		}

		public function set autoSize(value:int):void
		{
			_autoSize = value;
			reload();
		}
		
		/**
		 * 设置资源域名，默认是""
		 */		
		public static function set imgDomain(value:String):void
		{
			_imgDomain = value;
		}
		
		/**指定不进行自动缩放 */
		public static const AUTOSIZE_NONE:int = 0;	
		/**指定在宽度上自动缩放*/
		public static const AUTOSIZE_WIDTH:int = 1;
		/**指定在高度上自动缩放*/
		public static const AUTOSIZE_HEIGHT:int = 2;
		/**指定在自动缩放时重新请求原图。这将有效提升图片显示效果，但会增大服务器压力。
		 * <br>必须同时指定AUTOSIZE_WIDTH 和/或 AUTOSIZE_HEIGHT */
		public static const AUTOSIZE_RELOAD:int = 4;
		/**允许在自动缩放时放大，充满指定的宽和高
		 * <br>必须同时指定AUTOSIZE_WIDTH 和/或 AUTOSIZE_HEIGHT */
		public static const AUTOSIZE_FULL:int = 8;

		override public function setContent(skin:*, replace:Boolean=true, replaceSkin:*=null):void
		{
			super.setContent(skin, replace, replaceSkin);
			
			var tf:TextField = content as TextField;
			if(tf)
			{
				_width = tf.width;
				_height = tf.height;
				removeChild(tf);
				drawBg();
				_color = tf.textColor;
				_textSize = tf.defaultTextFormat.size as int;
				horizontalAlign = tf.defaultTextFormat.align; 
				data = tf.text;
				this.filters = tf.filters;
				
				skin.text = "";
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
			else
			{
				reload();
			}
		}
		
		public function get text():String
		{
			return String(data);
		}
		
		public function set text(value:String):void
		{
			this.data = value;
		}
		
		override public function set data(v:*):void
		{
			super.data = v;
			reload();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			drawBg();
			super.height = value;
			setTextSize();
		}
		
		private function drawBg():void
		{
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,_width, _height);
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			drawBg();
			super.width = value;
			setTextSize();
		}
		
		protected function reload(density:int = -1):void
		{
			if(!data || "" == data || "\r" == data)
				return;
			
			if(-1 == density)
				density = textSize * 10;
			_currentDensity = density;
			
			trace("[GLaTex] 原文", data);
			var url:String = MathUtils.latex2URL(text, density);
			url = _imgDomain + "/ltx/" + url + ".png";
			trace("[GLaTex] 载入", url);
			this.clearText();
			_loadUtilHandler = LoadUtil.loaderLoadWithoutSandbox(
				url,
				completeHandler,
				errorHandler,
				null,
				null,
				VersionUtil.VERSION_NONE,
				5000
			);
		}
		
		public function clearText():void
		{
			if(img.bitmapData != null)
			{
				img.bitmapData.dispose();
				img.bitmapData = null;
			}
			if(_loadUtilHandler != null)
			{
				_loadUtilHandler.clearLoad();
				_loadUtilHandler = null;
			}
		}
		
		private function completeHandler(loader:Loader):void
		{
			try
			{
				this.clearText();
				var temp:Bitmap = loader.content as Bitmap;
				loader.unloadAndStop();
				
				if(temp != null)
				{
					img.bitmapData = temp.bitmapData;
				}
				else
				{
					trace("[GLaTex] 载入的图片是意料外的对象。");
					return;
				}
			} 
			catch(error:Error) 
			{
			}
			
			trace("成功加载，放到场景上");
			setColor();
			setTextSize();
		}
		
		private function errorHandler(event:ErrorEvent):void 
		{
			if(event is IOErrorEvent)
			{
				trace("[GLaTex] ioErrorHandler: " + event);
			}
			else if(event is SecurityErrorEvent)
			{
				trace("[GLaTex] SecurityErrorEvent: " + event);
			}
		}
		
		private function setTextSize():void
		{
			if(img.bitmapData == null)
				return;
			
			img.scaleX = img.scaleY = 1;
			
			var xScale:Number = 1;
			if(autoSize & AUTOSIZE_WIDTH)
			{
				xScale = ( _width - 1 )  / img.width;
			}
			
			var yScale:Number = 1;
			if(autoSize & AUTOSIZE_HEIGHT)
			{
				yScale = ( _height - 1 )  / img.height;
			}
			
			var scale:Number = Math.min(xScale, yScale);
			if(!(autoSize & AUTOSIZE_FULL) && scale > 1)
			{
				scale = 1;
			}
			img.scaleX = img.scaleY = scale;
			
			
			switch(_horizontalAlign)
			{
				case ALIGN_LEFT:
					img.x = 0;
					break;
				
				case ALIGN_RIGHT:
					img.x = Math.floor(_width - img.width);
					break;
				
				case ALIGN_CENTER:
					img.x = Math.floor((_width - img.width) * 0.5);
					break;
			}
			
			switch(_verticalAlign)
			{
				case ALIGN_TOP:
					img.y = 0;
					break;
				
				case ALIGN_BOTTOM:
					img.y = Math.floor(_height - img.height);
					break;
				
				case ALIGN_CENTER:
					img.y = Math.floor((_height - img.height) * 0.5);
					break;
			}
			
			if(autoSize & AUTOSIZE_RELOAD && 1 != scale &&  textSize * 10 == _currentDensity)
			{
				trace("[GLaTex] 重新载入");
				reload( _currentDensity * scale);
			}
		}
		
		private function setColor():void
		{
			if(img.bitmapData == null)
				return;
			
			img.filters = [new ColorMatrixFilter([
				0, 0, 0, 0, (_color >> 16) & 255,
				0, 0, 0, 0, (_color >> 8) & 255,
				0, 0, 0, 0, _color & 255,
				0, 0, 0, 1, 0,
			])];
		}
		
	}
}