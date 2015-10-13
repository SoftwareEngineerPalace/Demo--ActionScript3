package
{
	import com.jason.utils.ExchangeSort_BubbleSort;
	import com.jason.utils.InsertionSort_ShellSort;
	import com.jason.utils.InsertionSort_StraightInsertionSort;
	
	import flash.display.Sprite;
	
	/**
	 * 排序算法学习
	 * @author jishu
	 */
	public class SortAlgorithm extends Sprite
	{
		private var raw:Array = [49,38,65,97,76,13,27,49,78,34,12,64,5,4,62,99,98,54,56,17,18,23,34,15,35,25,53,51];
		
		public function SortAlgorithm()
		{
			ExchangeSort_BubbleSort.excute( raw ) ;
			trace( raw.toString() ) ;
		}
	}
}