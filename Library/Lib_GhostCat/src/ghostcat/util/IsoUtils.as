/**
 *
 *@author <a href="mailto:jacob.zhang@happyelements.com">Jacob zhang</a>
 *@version $Id: IsoUtils.as 324055 2013-04-25 07:50:23Z jacob.zhang $
 *
 **/
package ghostcat.util
{
	import flash.geom.Point;

	public class IsoUtils
	{

		
		/**
		 * 根据像素坐标得到直角坐标	
		 * */
		public static  function getDirectPointByPixel(tileWidth:int, tileHeight:int, px:int, py:int,row:int):Point
		{
			return getDirectPoint(getCellPoint(tileWidth,tileHeight,px,py),row);
		}
		
		/**
		 * 根据网格坐标取得像素素坐标 
		 * @param tileWidth  網格宽
		 * @param tileHeight  網格高
		 * @param tx    網格X坐標
		 * @param ty  網格Y坐標
		 * @return 
		 * 
		 */		
		public static  function getPixelPoint(tileWidth:int, tileHeight:int, tx:int, ty:int):Point
		{
			/**
			 * 偶数行tile中心	
			 * */
			var tileCenter:int = (tx * tileWidth) + tileWidth/2;
			/**
			 * x象素  如果为奇数行加半个宽	
			 * */
			var xPixel:int = tileCenter + (ty&1) * tileWidth/2;
			
			/**
			 * y象素	
			 * */
			var yPixel:int = (ty + 1) * tileHeight/2;
			
			return new Point(xPixel, yPixel);
		}
		
		/**
		 * 根据逻辑坐标得到直角坐标	
		 * */
		public  static  function getDirectPoint(logic:Point,row:int):Point
		{
			/**
			 * 直角坐标点
			 * */
			var dPoint:Point = new Point();
			if(logic.y & 1){
				dPoint.x = Math.floor(( logic.x - logic.y / 2 ) + 1 + (row-1)/2);
			}else{
				dPoint.x = ( logic.x - logic.y / 2 ) + Math.ceil((row-1)/2);
			}
			dPoint.y = Math.floor(( logic.y / 2 ) + logic.x + ( logic.y & 1 ));
			return dPoint;
		}
		
		
		public static  function getCellPoint(tileWidth:int,tileHeight:int,px:int,py:int):Point
		{
			//网格X，Y坐标
			var tileX:int =0;
			var tileY:int = 0;
			
			var centerX:int,centerY:int,rx:int,ry:int;
			//计算出当前X所在的以TileWidth为宽的矩形的中心X，Y坐标
			centerX = int(px/tileWidth)*tileWidth+tileWidth/2;
			centerY = int(py/tileHeight)*tileHeight + tileHeight/2;
			
			rx = (px-centerX)*tileHeight/2;
			ry = (py-centerY)*tileWidth/2;
			
			if (Math.abs(rx)+Math.abs(ry) <= tileWidth * tileHeight/4)
			{
				tileX = int(px / tileWidth);
				tileY = int(py / tileHeight) * 2;
			}
			else
			{
				px = px - tileWidth/2;
				tileX = int(px / tileWidth) + 1;
				
				py = py - tileHeight/2;
				tileY = int(py / tileHeight) * 2 + 1;
			}
			
			return new Point(tileX - (tileY&1), tileY);
		}
		
		/**
		 * 字符串转point 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function string2Point(str :String):Point
		{
			var p :Point;
			if(str)
			{
				var ary :Array = str.split(",");
				if(ary.length >= 2)
				{
					var px :int = int(ary[0]);
					var py :int = int(ary[1]);
					p = new Point(px,py);
				}
			}else
			{
				trace("IsoUtil","string2Point str null");
			}
			if(!p)
			{
				trace("IsoUtil","string2Point str null");
			}
			return p;
		}
		/**
		 * 字符串转point数组 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function string2PointArr(str :String):Array
		{
			var result :Array = [];
			if(str)
			{
				var ary :Array = str.split(",");
				if(ary.length >= 2)
				{
					while(ary.length > 0)
					{
						var px :int = ary.shift();
						var py :int = ary.shift();
						var p :Point = new Point(px,py);
						result.push(p);
					}
				}
			}else
			{
				trace("IsoUtil","string2PointArr str null");
			}
			if(result.length == 0)
			{
				trace("IsoUtil","string2PointArr str null");
			}
			return result;
		}
		/**
		 * 地图字符串转数组 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function string2Array(str :String,rows :int,cols :int):Array
		{
			var result :Array = [];
			if(str)
			{
				var arr:Array  = str.split(",");
				var index:uint = 0;
				for(var i:uint = 0 ; i < rows;i++)
				{
					var tempArr:Array = new Array();
					for(var j:uint = 0 ; j < cols; j++)
					{
						var boolean :Boolean = arr[index] == "1" ? true : false;
						tempArr.push(boolean);
						index++;
					}
					result.push(tempArr);
				}
				return result;
				
			}else
			{
				trace("IsoUtil","string2Array str null");
			}
			
			if(result.length == 0)
			{
				trace("IsoUtil","string2Array str null");
			}
			
			return result;
		}
	}
}