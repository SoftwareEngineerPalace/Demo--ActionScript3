package com.vox.gospel.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BitmapFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 功能: 显示工具类
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class DisplayUtil
	{
		public function DisplayUtil()
		{
		}
		
		/**
		 * 移除指定容器内的所有显示对象
		 * @param container 要被移除子显示对象的容器对象
		 */		
		public static function removeAllChildren(container:DisplayObjectContainer):void {
			if(container == null) return;
			var num:int = container.numChildren;
			for(var i:int = 0; i < num; i++) {
				container.removeChildAt(0);
			}
		}
		
		/**
		 * 将列表中所有显示对象从其父容器中移除
		 * @param list 显示对象列表
		 */		
		public static function clearList(list:*):void {
			if(list == null) return;
			for(var i:int = 0, len:int = list.length; i < len; i++) {
				removeChild(list.pop());
			}
		}
		
		/**
		 * 添加显示对象到指定容器
		 * @param child 要添加的显示对象
		 * @param parent 要添加到的容器对象
		 * @return 返回被添加的显示对象，如果出错则返回null
		 */		
		public static function addChild(child:DisplayObject, parent:DisplayObjectContainer):DisplayObject {
			if(child != null && parent != null) {
				return parent.addChild(child);
			}
			return null;
		}
		
		/**
		 * 添加显示对象到指定容器的指定索引位置
		 * @param child 要添加的显示对象
		 * @param parent 要添加到的容器对象
		 * @param index 要添加到容器的索引值
		 * @return 返回被添加的显示对象，如果出错则返回null
		 */		
		public static function addChildAt(child:DisplayObject, parent:DisplayObjectContainer, index:int):DisplayObject {
			if(child != null && parent != null) {
				var numChildren:int = parent.numChildren;
				if(index < 0) index = 0;
				if(index > numChildren) index = numChildren;
				return parent.addChildAt(child, index);
			}
			return null;
		}
		
		/**
		 * 移除显示对象
		 * @param child 要被移除的显示对象
		 * @return 被移除的显示对象，如果出错则返回null
		 */		
		public static function removeChild(child:DisplayObject):DisplayObject {
			if(child != null) {
				var parent:DisplayObjectContainer = child.parent;
				if(parent != null) {
					return parent.removeChild(child);
				}
			}
			return null;
		}
		
		/**
		 * 根据指定索引值从容器中移除显示对象
		 * @param parent 要从中移除显示对象的容器
		 * @param index 移除操作指定的容器索引值
		 * @return 被移除的显示对象，如果出错则返回null
		 */		
		public static function removeChildAt(parent:DisplayObjectContainer, index:int):DisplayObject {
			if(parent != null) {
				if(index >= 0 && index < parent.numChildren) {
					return parent.removeChildAt(index);
				}
			}
			return null;
		}
		
		/**
		 * 获取指定显示对象上方的显示对象
		 * @param target 会获取该对象上方的显示对象
		 * @return 返回指定显示对象上方的显示对象，如果出错则返回null
		 */		
		public static function getChildUpon(target:DisplayObject):DisplayObject {
			if(target != null) {
				var parent:DisplayObjectContainer = target.parent;
				if(parent != null) {
					var index:int = parent.getChildIndex(target);
					// 越界的话返回null
					if(index < 0 || index >= parent.numChildren - 1) return null;
					return parent.getChildAt(index + 1);
				}
			}
			return null;
		}
		
		/**
		 * 获取指定显示对象下方的显示对象
		 * @param target 会获取该对象下方的显示对象
		 * @return 返回指定显示对象下方的显示对象，如果出错则返回null
		 */		
		public static function getChildBelow(target:DisplayObject):DisplayObject {
			if(target != null) {
				var parent:DisplayObjectContainer = target.parent;
				if(parent != null) {
					var index:int = parent.getChildIndex(target);
					// 越界的话返回null
					if(index <= 0 || index > parent.numChildren - 1) return null;
					return parent.getChildAt(index - 1);
				}
			}
			return null;
		}
		
		/**
		 * 添加显示对象到另一个显示对象的上方
		 * @param child 要被添加的显示对象
		 * @param target 被添加的显示对象将被放在该显示对象上方
		 * @return 返回被添加的显示对象，如果出错则返回null
		 */		
		public static function addChildUpon(child:DisplayObject, target:DisplayObject):DisplayObject {
			if(target != null) {
				var parent:DisplayObjectContainer = target.parent;
				if(parent != null) {
					DisplayUtil.removeChild(child);
					var index:int = parent.getChildIndex(target);
					return DisplayUtil.addChildAt(child, parent, index + 1);
				}
			}
			return null;
		}
		
		/**
		 * 添加显示对象到另一个显示对象的下方
		 * @param child 要被添加的显示对象
		 * @param target 被添加的显示对象将被放在该显示对象下方
		 * @return 返回被添加的显示对象，如果出错则返回null
		 */		
		public static function addChildBelow(child:DisplayObject, target:DisplayObject):DisplayObject {
			if(target != null) {
				var parent:DisplayObjectContainer = target.parent;
				if(parent != null) {
					DisplayUtil.removeChild(child);
					var index:int = parent.getChildIndex(target);
					return DisplayUtil.addChildAt(child, parent, index);
				}
			}
			return null;
		}
		
		/**
		 * 移除指定显示对象上方的显示对象
		 * @param target 会移除该显示对象上方的显示对象
		 * @return 返回被移除的显示对象，如果出错则返回null
		 */		
		public static function removeChildUpon(target:DisplayObject):DisplayObject {
			if(target != null) {
				var child:DisplayObject = getChildUpon(target);
				if(child != null) {
					var parent:DisplayObjectContainer = target.parent;
					return parent.removeChild(child);
				}
			}
			return null;
		}
		
		/**
		 * 移除指定显示对象下方的显示对象
		 * @param target 会移除该显示对象下方的显示对象
		 * @return 返回被移除的显示对象，如果出错则返回null
		 */		
		public static function removeChildBelow(target:DisplayObject):DisplayObject {
			if(target != null) {
				var child:DisplayObject = getChildBelow(target);
				if(child != null) {
					var parent:DisplayObjectContainer = target.parent;
					return parent.removeChild(child);
				}
			}
			return null;
		}
		
		/**
		 * 绘制扇形
		 * @param con 扇形的容器，支持Shape或Sprite及其子类
		 * @param x 扇形中心点横坐标
		 * @param y 扇形中心点纵坐标
		 * @param r 扇形半径
		 * @param angle 扇形开角角度值
		 * @param startFrom 扇形开角起始角度值
		 * @param fill 是否有填充，默认有
		 * @param fillColor 填充颜色
		 * @param fillAlpha 填充颜色alpha值
		 * @param line 是否有边线，默认没有
		 * @param lineThickness 边线粗细
		 * @param lineColor 边线颜色
		 * @param lineAlpha 边线alpha值
		 */		
		public static function drawSector(con:*,
										  x:Number = 100,
										  y:Number = 100,
										  r:Number = 100,
										  angle:Number = 90,
										  startFrom:Number = 270,
										  fill:Boolean = true,
										  fillColor:uint = 0,
										  fillAlpha:Number = 1,
										  line:Boolean = false,
										  lineThickness:int = 1,
										  lineColor:uint = 0,
										  lineAlpha:Number = 1):void
		{
			if(!(con is Shape || con is Sprite)) return;
			var g:Graphics = con.graphics;
			if(fill) g.beginFill(fillColor, fillAlpha);
			if(line) g.lineStyle(lineThickness, lineColor, lineAlpha);
			g.moveTo(x, y);
			angle = (Math.abs(angle) > 360) ? 360 : angle;
			var n:int = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			g.lineTo(x + r * Math.cos(startFrom), y + r * Math.sin(startFrom));
			for (var i:int = 1; i <= n; i++) {
				startFrom += angleA;
				var angleMid:Number = startFrom - angleA / 2;
				var bx:Number = x + r / Math.cos(angleA / 2) * Math.cos(angleMid);
				var by:Number = y + r / Math.cos(angleA / 2) * Math.sin(angleMid);
				var cx:Number = x + r * Math.cos(startFrom);
				var cy:Number = y + r * Math.sin(startFrom);
				g.curveTo(bx, by, cx, cy);
			}
			if (angle!=360) {
				g.lineTo(x, y);
			}
			if(fill) g.endFill();
		}
		
		/**
		 * 绘制一个圆弧
		 * @param con 圆弧的容器，支持Shape或Sprite及其子类
		 * @param x 圆弧中心点横坐标
		 * @param y 圆弧中心点纵坐标
		 * @param r 圆弧的半径
		 * @param angle 扇形开角角度值
		 * @param startFrom 扇形开角起始角度值
		 * @param lineThickness 边线粗细
		 * @param lineColor 边线颜色
		 * @param lineAlpha 边线alpha值
		 */		
		public static function drawArcLine(con:*,
										   x:Number = 100,
										   y:Number = 100,
										   r:Number = 100,
										   angle:Number = 90,
										   startFrom:Number = 270,
										   lineThickness:int = 1,
										   lineColor:uint = 0,
										   lineAlpha:Number = 1):void
		{
			if(!(con is Shape || con is Sprite)) return;
			var g:Graphics = con.graphics;
			g.lineStyle(lineThickness, lineColor, lineAlpha);
			g.moveTo(x, y);
			angle = (Math.abs(angle) > 360) ? 360 : angle;
			var n:int = Math.ceil(Math.abs(angle) / 45);
			var angleA:Number = angle / n;
			angleA = angleA * Math.PI / 180;
			startFrom = startFrom * Math.PI / 180;
			g.moveTo(x + r * Math.cos(startFrom), y + r * Math.sin(startFrom));
			for (var i:int = 1; i <= n; i++) {
				startFrom += angleA;
				var angleMid:Number = startFrom - angleA / 2;
				var bx:Number = x + r / Math.cos(angleA / 2) * Math.cos(angleMid);
				var by:Number = y + r / Math.cos(angleA / 2) * Math.sin(angleMid);
				var cx:Number = x + r * Math.cos(startFrom);
				var cy:Number = y + r * Math.sin(startFrom);
				g.curveTo(bx, by, cx, cy);
			}
		}
		
		/**
		 * 对一个Rectangle对象实施一个Matrix转换，得到一个转换后的Rectangle对象
		 * @param rect 要实施转换的Rectangle对象
		 * @param matrix Matrix转换对象
		 * @return 转换后的结果Rectangle对象
		 */		
		public static function transformRectangle(rect:Rectangle, matrix:Matrix):Rectangle {
			// 获取原始矩形4个点坐标
			var pt0:Point = rect.topLeft;
			var pt1:Point = new Point(rect.right, rect.top);
			var pt2:Point = rect.bottomRight;
			var pt3:Point = new Point(rect.left, rect.bottom);
			// 开始转换
			pt0 = matrix.transformPoint(pt0);
			pt1 = matrix.transformPoint(pt1);
			pt2 = matrix.transformPoint(pt2);
			pt3 = matrix.transformPoint(pt3);
			// 计算新矩形4个定点的最小值和最大值
			var minX:Number = Math.min(pt0.x, pt1.x, pt2.x, pt3.x);
			var maxX:Number = Math.max(pt0.x, pt1.x, pt2.x, pt3.x);
			var minY:Number = Math.min(pt0.y, pt1.y, pt2.y, pt3.y);
			var maxY:Number = Math.max(pt0.y, pt1.y, pt2.y, pt3.y);
			// 返回新的矩形
			var result:Rectangle = new Rectangle(minX, minY, maxX - minX, maxY - minY);
			return result;
		}
		
		/**
		 * 对一个Rectangle对象实施一个Matrix转换，得到一个转换后的Rectangle对象，与transformRectangle不同的是，该转换将忽略matrix的tx和ty属性
		 * @param rect 要实施转换的Rectangle对象
		 * @param matrix Matrix转换对象
		 * @return 转换后的结果Rectangle对象
		 */		
		public static function deltaTransformRectangle(rect:Rectangle, matrix:Matrix):Rectangle {
			// 获取原始矩形4个点坐标
			var pt0:Point = rect.topLeft;
			var pt1:Point = new Point(rect.right, rect.top);
			var pt2:Point = rect.bottomRight;
			var pt3:Point = new Point(rect.left, rect.bottom);
			// 开始转换
			pt0 = matrix.deltaTransformPoint(pt0);
			pt1 = matrix.deltaTransformPoint(pt1);
			pt2 = matrix.deltaTransformPoint(pt2);
			pt3 = matrix.deltaTransformPoint(pt3);
			// 计算新矩形4个定点的最小值和最大值
			var minX:Number = Math.min(pt0.x, pt1.x, pt2.x, pt3.x);
			var maxX:Number = Math.max(pt0.x, pt1.x, pt2.x, pt3.x);
			var minY:Number = Math.min(pt0.y, pt1.y, pt2.y, pt3.y);
			var maxY:Number = Math.max(pt0.y, pt1.y, pt2.y, pt3.y);
			// 返回新的矩形
			var result:Rectangle = new Rectangle(minX, minY, maxX - minX, maxY - minY);
			return result;
		}
		
		/**
		 * 添加一个滤镜到DisplayObject对象上
		 * @param target 要被添加滤镜的DisplayObject对象
		 * @param filter 要添加的滤镜
		 */		
		public static function addFilter(target:DisplayObject, filter:BitmapFilter):void {
			var filters:Array = target.filters;
			if(filters.indexOf(filter) < 0) {
				filters.push(filter);
			}
			target.filters = filters;
		}
		
		/**
		 * 从DisplayObject对象上删除指定滤镜
		 * @param target 被删除滤镜的DisplayObject对象
		 * @param filter 要被删除的滤镜
		 */		
		public static function removeFilter(target:DisplayObject, filter:BitmapFilter):void {
			var filters:Array = target.filters;
			var index:int = filters.indexOf(filter);
			if(index >= 0) {
				filters.splice(index, 1);
			}
			target.filters = filters;
		}
	}
}