package com.jason.bmptool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ghostcat.display.GBase;
	
	/**
	 * 功能: 
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class InfinityBitmap extends GBase
	{
		private var _bitmap:Bitmap;
		private var _bdSource:BitmapData;
		private var _curX:Number = 0;
		private var _curY:Number = 0;
		
		private var _viewRange:Rectangle;
		private var _speedH:Number = 0;
		private var _speedV:Number = 0;
		
		private var _filter:Array;
		
		override public function set filters(value:Array):void
		{
			_filter = value;
		}
		
		public var container:Sprite;

		/** 设置显示范围，即显示对象可见部分在其自身内部的范围 */
		public function set viewRange(value:Rectangle):void
		{
			if(this.skin == null) return;
			_viewRange = value;
			// 计算总宽高
			var maxW:Number = _viewRange.width;
			var maxH:Number = _viewRange.height;
			if(maxW < 1) maxW = 1;
			if(maxH < 1) maxH = 1;
			// 更新BitmapData
			if(_bdSource != null) _bdSource.dispose();
			_bitmap.bitmapData = new BitmapData(maxW, maxH);
			_bdSource = new BitmapData(_viewRange.width + 1, _viewRange.height + 1, true, 0);
			var skinBitmap:Bitmap = this.skin as Bitmap;
			if(skinBitmap != null)
			{
				var range:Rectangle = _viewRange.clone();
				range.width += 1;
				range.height += 1;
				_bdSource.copyPixels(skinBitmap.bitmapData, range, new Point());
			}
			else
			{
				var matrix:Matrix = new Matrix();
				matrix.translate(-_viewRange.x, -_viewRange.y);
				_bdSource.draw(this.skin, matrix);
			}
			// 更新显示用的BitmapData
			var bd:BitmapData = _bitmap.bitmapData;
			if(bd != null) bd.dispose();
			_bitmap.bitmapData = new BitmapData(maxW, maxH);
			// 更新一次显示
			updateView();
		}
		
		/** 获取或设置横向速度，像素/秒为单位 */
		public function get speedH():Number
		{
			return _speedH;
		}
		public function set speedH(value:Number):void
		{
			_speedH = value;
		}
		
		/** 获取或设置纵向速度，像素/秒为单位 */
		public function get speedV():Number
		{
			return _speedV;
		}
		public function set speedV(value:Number):void
		{
			_speedV = value;
		}
		
		public function InfinityBitmap(skin:*=null)
		{
			super(skin);
			// 生成显示用Bitmap
			_bitmap = new Bitmap();
			this.addChild(_bitmap);
			// 生成跟随容器
			container = new Sprite();
			this.addChild(container);
		}
		
		public function setSkin(skin:*):void
		{
			this.setContent(skin);
			if(this.skin != null)
			{
				// 先移除默认的显示内容
				this.removeChild(this.skin);
				if(this.stage != null)
				{
					// 设置初始可见范围，即显示对象本身全部范围
					var displayObj:DisplayObject = this.skin as DisplayObject;
					var range:Rectangle = displayObj.getRect(displayObj);
					range = range.intersection(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
					this.viewRange = range;
				}
				else
				{
					var self:InfinityBitmap = this;
					this.addEventListener(Event.ADDED_TO_STAGE, function (event:Event):void
					{
						self.removeEventListener(Event.ADDED_TO_STAGE, arguments.callee);
						// 设置初始可见范围，即显示对象本身全部范围
						var displayObj:DisplayObject = self.skin as DisplayObject;
						var range:Rectangle = displayObj.getRect(displayObj);
						range = range.intersection(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
						self.viewRange = range;
					});
				}
			}
		}
		
		private function updateView():void
		{
			if(_viewRange == null) return;
			// 获取一个循环内的横纵变更量
			var standardWidth:Number = _viewRange.right;
			var deltaH:Number = _curX % standardWidth;
			if(deltaH < 0) deltaH += standardWidth;
			var standardHeight:Number = _viewRange.bottom;
			var deltaV:Number = _curY % standardHeight;
			if(deltaV < 0) deltaV += standardHeight;
			// 使用copyPixels方法
			var bd:BitmapData = _bitmap.bitmapData;
			var rect:Rectangle = new Rectangle(0, 0, bd.width, bd.height);
			var pt:Point = new Point();
			
			bd.fillRect(new Rectangle(0, 0, bd.width, bd.height), 0);
			// 绘制左上部分
			pt.setTo(deltaH - standardWidth, deltaV - standardHeight);
			bd.copyPixels(_bdSource, rect, pt);
			// 绘制右上部分
			pt.setTo(deltaH, deltaV - standardHeight);
			bd.copyPixels(_bdSource, rect, pt);
			// 绘制左下部分
			pt.setTo(deltaH - standardWidth, deltaV);
			bd.copyPixels(_bdSource, rect, pt);
			// 绘制右下部分
			pt.setTo(deltaH, deltaV);
			bd.copyPixels(_bdSource, rect, pt);
			// 更新位置
			_bitmap.x = _viewRange.x;
			_bitmap.y = _viewRange.y;
			// 更新滤镜
			if(_filter != null)
			{
				pt.setTo(0, 0);
				rect.setTo(0, 0, bd.width, bd.height);
				for(var i:int = 0, len:int = _filter.length; i < len; i++)
				{
					var filter:BitmapFilter = _filter[i] as BitmapFilter;
					if(filter != null)
					{
						bd.applyFilter(bd, rect, pt, filter);
					}
				}
			}
			// 调整container的位置
			container.x = _curX;
			container.y = _curY;
		}
		
		/**
		 * 外部调用的驱动方法
		 * @param delta 与上一次tick相差的毫秒数
		 */		
		public function onTick(delta:int):void
		{
			if(_speedH != 0 || _speedV != 0)
			{
				_curX += _speedH * (delta * 0.001);
				_curY += _speedV * (delta * 0.001);
				updateView();
			}
		}
		
		override public function destory():void
		{
			super.destory();
			if(_bdSource != null)
			{
				_bdSource.dispose();
				_bdSource = null;
			}
			_bitmap = null;
			_viewRange = null;
		}
	}
}