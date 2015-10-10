package com.jason.utils
{
	/**
	 * 插入排序-希尔排序
	 * 希尔排序(Shell Sort)是插入排序的一种。也称缩小增量排序，是直接插入排序算法的一种更高效的改进版本。希尔排序是非稳定排序算法
	 * 时间复杂度 N^1.5
	 * @author jishu
	 */
	public class InsertionSort_ShellSort
	{
		public function InsertionSort_ShellSort()
		{
		}
		
		public static function excute( arr:Array ):void
		{
			standard( arr ) ;
		}
		
		private static function standard( arry:Array):void  
		{  
			var gap:int=arry.length/2;
			while(gap>=1)
			{
				for(var i:int=gap;i<arry.length;i++)
				{
					var temp:int=arry[i];
					for(var j:int=i;j>=gap&&arry[j-gap]>temp;j-=gap)
					{
						arry[j]=arry[j-gap];
					}
					arry[j]=temp;
				}
				gap/=2;
			}
		}  
	}
}