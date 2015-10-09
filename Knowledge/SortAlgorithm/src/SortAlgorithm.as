package
{
	import flash.display.Sprite;
	
	/**
	 * 排序算法学习
	 * @author jishu
	 */
	public class SortAlgorithm extends Sprite
	{
		public function SortAlgorithm()
		{
			test_directInsertSort( raw ) ;
			trace( raw.toString() ) ;
		}
		
		private var raw:Array = [ 23, 52, 28, 24, 46, 33, 18 ] ;
		/**
		 * 直接插入排序  这是抄网页上的  http://baike.baidu.com/link?url=wnJv1TSIEhrJ2ODQ3XLfAlTBXaLYHwcBTinYtRj4ekxZh_yK2CcqDiEHImpXTkgJGusy8GZNKLQZZKz-4vofbK
		 */
		private function copy_directInsertSort( array:Array ):void
		{
			for( var i:uint = 1, len:uint = array.length ; i < len ; i++ )//第0位独自作为有序数列，从第1位开始向后遍历
			{
				if(array[i]<array[i-1])//0~i-1位为有序，若第i位大于i-1位，继续寻位并插入，否则认为0~i位也是有序的，忽略此次循环，相当于continue
				{
					var temp:uint = array[i];//保存第i位的值
					var k:uint = i - 1;
					for( var j:uint=k;j>=0 && temp<array[j];j--)//从第i-1位向前遍历并移位，直至找到小于第i位值停止
					{
						array[j+1]=array[j];
						k--;
					}
					array[k+1]=temp;//插入第i位的值
				}
			} 
		}
		
		/**
		 * 直接插入排序  练习成功 肖建军@2015-10-09
		 * @param $arr
		 */
		private function test_directInsertSort( $arr:Array ):void
		{
			for (var i:int = 1, len:uint = $arr.length; i < len; i++) 
			{
				if( $arr[i-1] > $arr[ i ] )
				{
					var tmp:uint = $arr[ i ] ;
					var k:uint = i - 1 ;
					for (var j:int = k; j >= 0 && $arr[ j ] > tmp; j--) 
					{
						$arr[j+1] = $arr[j];
						k -- ;
					}
					$arr[ k + 1 ] = tmp ;
				}
			}
		}
	}
}