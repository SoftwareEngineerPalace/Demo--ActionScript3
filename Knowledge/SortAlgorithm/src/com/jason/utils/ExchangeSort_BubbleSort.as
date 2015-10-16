package com.jason.utils
{
	public class ExchangeSort_BubbleSort
	{
		public function ExchangeSort_BubbleSort()
		{
		}
		
		public static function excute( arr:Array ):void
		{
			test05( arr ) ;
		}
		
		private static function standard( arr:Array ):void
		{
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				for (var j:int = i + 1; j < len; j++)
				{
					if ( arr[j] < arr[i] )
					{
						var t:* = arr[i];
						arr[i] = arr[j];
						arr[j] = t;
					}
				}
			}
		}
		
		private static function test( $arr:Array ):void
		{
			for (var i:int = 0, len:uint = $arr.length ; i < len ; i++ ) 
			{
				for (var j:int = i + 1; j < len; j++) 
				{
					if( $arr[ j ] < $arr[ i ] )
					{
						var tmp:* = $arr[ i ] ;
						$arr[ i ] = $arr[ j ] ;
						$arr[ j ] = tmp ;
					}
				}
			}
		}
		
		/**
		 * 肖建军  练习成功 @2015-10-13 
		 * @param $arr
		 */
		private static function test02( $arr:Array ):void
		{
			for (var i:int = 0, len:uint = $arr.length; i < len; i++) 
			{
				for (var j:int = i + 1; j < len; j++) 
				{
					if( $arr[ j ] < $arr[ i ] )
					{
						var tmp:* = $arr[ i ] ;
						$arr[ i ] = $arr[ j ] ;
						$arr[ j ] = tmp ;
					}
				}
			}
		}
		
		/**
		 * 肖建军 @2015-10-16 
		 */
		private static function test05( $value:Array ):void
		{
			for (var i:int = 0, len:uint = $value.length; i < len; i++) 
			{
				for (var j:int = i+1 ; j < len; j++) 
				{
					if( $value[ j ] <　$value[ i ] )
					{
						var tmp:* = $value[ j ] ;
						$value[ j ] = $value[ i ] ;
						$value[ i ] = tmp ;
					}
				}
				
			}
		}
	}
}