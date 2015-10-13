package com.jason.utils
{
	/**
	 * 插入排序-直接插入排序
	 * @author jishu
	 */
	public class InsertionSort_StraightInsertionSort
	{
		public function InsertionSort_StraightInsertionSort()
		{
		}
		
		public static function excute( $arr:Array ):void
		{
			test05( $arr ) ;
		}
		
		/**
		 * 插入排序-直接插入排序  这是抄网页上的  http://baike.baidu.com/link?url=wnJv1TSIEhrJ2ODQ3XLfAlTBXaLYHwcBTinYtRj4ekxZh_yK2CcqDiEHImpXTkgJGusy8GZNKLQZZKz-4vofbK
		 */
		private static function copy_straightInsertionSort( array:Array ):void
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
		
		private static function test03_straightInsertionSort( $arr:Array ):void
		{
			for (var i:int = 1, len:uint = $arr.length ; i < len; i++ ) 
			{
				if( $arr[ i ] < $arr[ i - 1 ] )
				{
					var tmp:uint = $arr[ i ] ;
					var k:uint = i - 1 ;
					for (var j:int = k; j >= 0 && $arr[ j ] > tmp ; j--) 
					{
						$arr[ j + 1 ] = $arr[ j ] ;
						k -- ;
					}
					$arr[ k + 1 ] = tmp ;
				}
			}
		}
		
		/**
		 * 直接插入排序-直接插入排序  练习01成功  肖建军@2015-10-09
		 * @param $arr
		 */
		private static function test_straightInsertionSort( $arr:Array ):void
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
		
		/**
		 * 直接插入排序-直接插入排序 练习02成功 肖建军@2015-10-10
		 * @param $arr
		 */
		private static function test02_straightInsertionSort( $arr:Array ):void
		{
			for (var i:int = 1, len:uint = $arr.length ; i < len ; i++ ) 
			{
				if( $arr[ i ] < $arr[ i - 1 ] )
				{
					var bak:int = $arr[ i ] ;
					var k:uint = i - 1 ;
					for (var j:int = k; j>=0 && $arr[j] > bak ; j--) 
					{
						$arr[ j + 1 ] = $arr[ j ] ;
						k -- 
					}
					$arr[ k + 1 ] = bak ;
				}
			}
		}
		
		private static function test05( a:Array ):void
		{
			var i:uint, j:uint;
			var temp:Number;
			for (i = 1; i < a.length ; i++)
			{
				temp = a[i];
				j = i - 1;
				while (j >= 0 && temp < a[j])
				{
					a[j + 1] = a[j];
					j--;
				}
				a[j + 1] = temp;
			}
		}
	}
}