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
		private var raw:Array = [ 89, 40, 20, 24, 80] ;
		
		public function SortAlgorithm()
		{
			ExchangeSort_BubbleSort.excute( raw ) ;
			trace( raw.toString() ) ;
		}
	}
}