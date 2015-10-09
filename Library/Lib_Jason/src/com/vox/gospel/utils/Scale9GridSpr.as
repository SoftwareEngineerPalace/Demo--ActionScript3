package com.vox.gospel.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 九切片类 
	 * @author Xiaojianjun
	 * <br/> version 1.0 
	 * <br/> 功能:     随着整体的大小变化，外框的尺寸不能变. 
	 * <br/> 使用方法:
	 * <br/> 1 传入的是要显示的DisplayObject和 选定的中间Rectangle 注意要给这个Rectangle设置x和y值 然后立即绘制九宫
	 * <br/> 2 设定width 和  height 
	 * <br/> 3 最后merge生成要的东西.
	 */	
	public class Scale9GridSpr extends Sprite
	{
		//-----------------------------------------------数据型变量---------------------------------------------/
		private var _rect                              :Rectangle;
		private var _bmp                               :Bitmap;
		private var _width                             :Number;
		private var _height                            :Number;
		
		//-----------------------------------------------显示型变量----------------------------------------------/
		private var _left_up_bmp                       :Bitmap;//左上
		private var _up_bmp                            :Bitmap;//上
		private var _right_up_bmp                      :Bitmap;//右上
		
		private var _left_center_bmp                   :Bitmap;//左中
		private var _center_bmp                        :Bitmap;//中
		private var _right_center_bmp                  :Bitmap;//右中
		
		private var _left_bottom_bmp                   :Bitmap;//左下
		private var _bottom_bmp                        :Bitmap;//下
		private var _right_bottom_bmp:Bitmap;//右下
		
		/**
		 * @intro 把传入的DisplayObject生成一个BitmapData --> Bitmap 同时准备好一个Rectangle. 
		 * @param displayObject
		 * @param rect
		 */		
		public function Scale9GridSpr(displayObject:DisplayObject, rect:Rectangle)
		{
			super();
			var bmd:BitmapData = new BitmapData(displayObject.width, displayObject.height, true, 0);
			bmd.draw(displayObject);
			this._bmp = new Bitmap(bmd);
			this._rect = rect;
			convertBmp();
		}
	
		/**
		 * 强制设置宽度 
		 * @param value
		 */		
		override public function set width(value:Number):void
		{
			this._width = value;
			if( value - _left_up_bmp.width  - _right_up_bmp.width  > 0 ) 
			{
				_up_bmp.width = value - _left_up_bmp.width  - _right_up_bmp.width ; //最上面行中间格的宽度 = 整体的宽度 - 两边格的宽度
				_center_bmp.width = _up_bmp.width;//中间行中间的宽度值，同上
				_bottom_bmp.width = _up_bmp.width;//最下行中间的宽度值，同上
				
				/*第三列的x值 会有变化*/
				_right_up_bmp.x = _left_up_bmp.width + _up_bmp.width - 2 ;
				_right_center_bmp.x = _right_up_bmp.x ;
				_right_bottom_bmp.x = _right_up_bmp.x ;
			}
			else
			{
				_up_bmp.width = 0 ;
				_center_bmp.width = 0 ;
				_bottom_bmp.width = 0 ;
				_right_up_bmp.x = value - _right_up_bmp.width ;
				_right_center_bmp.x = _right_up_bmp.x ;
				_right_bottom_bmp.x = _right_up_bmp.x ;
			}
		}
		
		/**
		 * 强制设置高度
		 * @param value
		 */
		override public function set height(value:Number):void
		{
			this._height = value;
			_left_center_bmp.height = value - _up_bmp.height - _bottom_bmp.height;//最左边列中间格的高度 = 整体的高度 - 上下两格的高度.
			_center_bmp.height = _left_center_bmp.height;//中间列的高度，同上 
			_right_center_bmp.height = _left_center_bmp.height;//最右列的高度，同上
			
			/*第三行的y值会有变化*/
			_left_bottom_bmp.y = _left_up_bmp.height + _left_center_bmp.height;
			_bottom_bmp.y = _left_bottom_bmp.y;
			_right_bottom_bmp.y = _left_bottom_bmp.y;
		}
		
		/**
		 * @intro  把this draw到BitmapData上放到Bitmap里，然后把this里的东西清除，addChild(bmp);
		 */		
		public function merge():void
		{
			var bmd:BitmapData = new BitmapData(_right_bottom_bmp.x + _right_bottom_bmp.width,  _right_bottom_bmp.y + _right_bottom_bmp.height, true, 0);
			bmd.draw(this);
			var bmp:Bitmap = new Bitmap(bmd);
			while(this.numChildren)
			{
				this.removeChildAt(0);
			}
			this.addChild(bmp);
		}
		
		
		
		//-----------------------------------------------------获得宽度和高度---------------------------------*/
		override public function get width():Number
		{
			return super.width;
		}
		
		
		override public function get height():Number
		{
			return super.height;
		}
		
		
	
		//------------------------------------------私有工具------------------------------------------------------------------------/
		
		/**
		 * @intro 从总Bitmap中copyPixels()那部分来.
		 * @param x
		 * @param y
		 * @param w
		 * @param h
		 * @return 
		 */		
		private function produceBmp(x:int, y:int, w:int, h:int):Bitmap
		{
			var bmd:BitmapData = new BitmapData(w, h, true, 0);
			bmd.copyPixels(_bmp.bitmapData, new Rectangle(x, y, w, h), new Point(0,0));
			var bmp:Bitmap = new Bitmap(bmd);
			bmp.x = x;
			bmp.y = y;
			this.addChild(bmp);
			return bmp;
		}
		
		/**
		 * @intro 生成一个大的Bitmap 
		 */		
		private function convertBmp():void
		{
			var x1:int = 0;
			var x2:int = _rect.x;
			var x3:int = _rect.x + _rect.width;
			
			var y1:int = 0;
			var y2:int = _rect.y;
			var y3:int = _rect.y + _rect.height;
			
			var w1:int = _rect.x;
			var w2:int = _rect.width;
			var w3:int = _bmp.width - _rect.x - _rect.width;
			
			var h1:int = _rect.y;
			var h2:int = _rect.height;
			var h3:int = _bmp.height - _rect.y - _rect.height;
			
			_left_up_bmp = produceBmp(x1, y1, w1, h1);
			_up_bmp = produceBmp(x2, y1, w2, h1);
			_up_bmp.x -= 1 ;
			_right_up_bmp = produceBmp(x3, y1, w3, h1);
			
			_left_center_bmp = produceBmp(x1, y2 ,w1, h2);
			_center_bmp = produceBmp(x2, y2, w2, h2);
			_center_bmp.x -= 1 ;
			_right_center_bmp = produceBmp(x3, y2, w3, h2);
			
			_left_bottom_bmp = produceBmp(x1, y3, w1, h3);
			_bottom_bmp = produceBmp(x2, y3, w2, h3);
			_bottom_bmp.x -= 1 ;
			_right_bottom_bmp = produceBmp(x3, y3, w3, h3);
		}
	}
}