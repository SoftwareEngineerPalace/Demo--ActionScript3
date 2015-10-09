package com.vox.future.utils
{
	
	public class NumberUtils 
	{
		
		private static var _aUniqueIDs:Array;
		
		/**
		 *  Round a number. By default the number is rounded to the nearest
		 *  integer. Specifying a roundToInterval parameter allows you to round
		 *  to the nearest of a specified interval.
		 *  @param  number             The number you want to round.
		 *  @param  nRoundToInterval   (optional) The interval to which you want to
		 *                             round the number. The default is 1.
		 *  @return                    The number rounded to the nearest interval.
		 */
		public static function round(nNumber:Number, nRoundToInterval:Number = 1):Number 
		{
			// Return the result
			return Math.round(nNumber / nRoundToInterval) * nRoundToInterval;
		}
		
		
		/**
		 *  Get the floor part of a number. By default the integer part of the
		 *  number is returned just as if calling Math.floor( ). However, by specifying
		 *  a roundToInterval, you can get non-integer floor parts.
		 *  to the nearest of a specified interval.
		 *  @param  number             The number for which you want the floor part.
		 *  @param  nRoundToInterval   (optional) The interval to which you want to
		 *                             get the floor part of the number. The default is 1.
		 *  @return                    The floor part of the number.
		 */
		public static function floor(nNumber:Number, nRoundToInterval:Number = 1):Number 
		{
			
			// Return the result
			return Math.floor(nNumber / nRoundToInterval) * nRoundToInterval;
		}
		
		/**
		 *  Get the ceiling part of a number. By default the next highested integer
		 *  number is returned just as if calling Math.ceil( ). However, by specifying
		 *  a roundToInterval, you can get non-integer ceiling parts.
		 *  to the nearest of a specified interval.
		 *  @param  number             The number for which you want the ceiling part.
		 *  @param  nRoundToInterval   (optional) The interval to which you want to
		 *                             get the ceiling part of the number. The default is 1.
		 *  @return                    The ceiling part of the number.
		 */
		public static function ceil(nNumber:Number, nRoundToInterval:Number = 1):Number 
		{
			
			// Return the result
			return Math.ceil(nNumber / nRoundToInterval) * nRoundToInterval;
		}
		
		/**
		 *  Generate a random number within a specified range. By default the value
		 *  is rounded to the nearest integer. You can specify an interval to which
		 *  to round the value.
		 *  @param  minimum            The minimum value in the range.
		 *  @param  maximum            (optional) The maxium value in the range. If
		 omitted, the minimum value is used as the maximum,
		 and 0 is used as the minimum.
		 *  @param  roundToInterval    (optional) The interval to which to round.
		 *  @return                    The random number.
		 */
		public static function random(nMinimum:Number, nMaximum:Number = 0, nRoundToInterval:Number = 1):Number 
		{
			// If the minimum is greater than the maximum, switch the two.
			if(nMinimum > nMaximum) {
				var nTemp:Number = nMinimum;
				nMinimum = nMaximum;
				nMaximum = nTemp;
			}
			
			// Calculate the range by subtracting the minimum from the maximum. Add
			// 1 times the round to interval to ensure even distribution.
			var nDeltaRange:Number = (nMaximum - nMinimum) + (1 * nRoundToInterval);
			
			// Multiply the range by Math.random(). This generates a random number
			// basically in the range, but it won't be offset properly, nor will it
			// necessarily be rounded to the correct number of places yet.
			var nRandomNumber:Number = Math.random() * nDeltaRange;
			
			// Add the minimum to the random offset to generate a random number in the correct range.
			nRandomNumber += nMinimum;
			
			// Return the random value. Use the custom floor( ) method to ensure the
			// result is rounded to the proper number of decimal places.
			return floor(nRandomNumber, nRoundToInterval);
		}
		
		/**
		 *  Generate a unique number.
		 *  @return                    The unique number
		 */
		public static function getUnique():Number 
		{
			
			if(_aUniqueIDs == null) 
			{
				_aUniqueIDs = new Array();
			}
			
			// Create a number based on the current date and time. This will be unique
			// in most cases.
			var dCurrent:Date = new Date();
			var nID:Number = dCurrent.getTime();
			
			// It is possible that the value may not be unique if it was generated
			// within the same millisecond as a previous number. Therefore, check to
			// make sure. If it is not unique, then generate a random value and concatenate
			// it with the previous one.
			while(!isUnique(nID)) 
			{
				nID += NumberUtils.random(dCurrent.getTime(), 2 * dCurrent.getTime());
			}
			
			_aUniqueIDs.push(nID);
			
			// Return the number.
			return nID;  
		}
		
		/**
		 *  Check to see if a number is unique within the array of stored numbers.
		 *  @param  number            The number to compare.
		 *  @return                   True or false
		 */
		private static function isUnique(nNumber:Number):Boolean
		{
			for(var i:Number = 0; i < _aUniqueIDs.length; i++) 
			{
				if(_aUniqueIDs[i] == nNumber)
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Test if a Number is an integer.
		 * @return true if Number is a integer.
		 */
		public static function isInteger ( n : Number ) : Boolean
		{
			return int( n ) == n;
		}
		
		/**
		 * Clamp a number betwen min and max value.
		 * @param n The Number to clamp.
		 * @param min The minimum value for the Number.
		 * @param max The maximum value for the Number.
		 * @param throwError A Boolean that indicates if Number out of range throw an Error or is clamp to match min or max value.
		 * @return The Number between min and max value.
		 * @throws A Error if Number is out of range and throwError argument is true.
		 */
		public static function clamp ( n : Number , min : Number = Number.NEGATIVE_INFINITY , max : Number = Number.POSITIVE_INFINITY , throwError : Boolean = false ) : Number
		{
			if( throwError && ( n < min || n > max || isNaN( n ) ) ) throw new Error( "Number " + n + " is out of range; minimum > " + min + "; maximum > " + max );
			
			if( n < min || isNaN( n ) ) n = min;
			else if( n > max ) n = max;
			
			return n;
		}
		
		/**
		 * Get the number sign (positive or negative).
		 * 
		 * @return 1 if positive else -1 if negative.
		 */
		public static function sign( n : Number ) : int
		{
			return n < 0 ? -1 : 1;
		}
		
		/**
		 * Convert A Number to a string money format.
		 * @param n The Number to convert.
		 * @param floatSeparator The char used as float.
		 * @param thousSeparator The char used for thousand separator.
		 * @return The Number converted to money format.
		 */
		public static function moneyFormat ( n : Number , floatSeparator : String = "." , thousSeparator : String = " " ) : String
		{
			var float : String = String( n.toFixed( 2 ) ).slice( -2 );
			var s : String = String( n ).split( "." )[ 0 ];
			var aSplit : Array = new Array( );
			
			while( s.slice( -3 ).length == 3 )
			{
				aSplit.push( thousSeparator + s.slice( -3 ) );
				s = s.substr( 0 , s.length - 3 );
			}
			
			aSplit.reverse( );
			
			s = s + aSplit.join( "" ) + floatSeparator + float;
			
			if( s.charAt( 0 ) == thousSeparator ) s = s.substr( 1 );
			
			return s;
		}
		
		/**
		 * Convert a Number to a string digit format.
		 * @param n The Number to convert.
		 * @param length The minimum Number of digit.
		 * @return The Number with all "0" necessary to match digit length.
		 */
		public static function digitFormat( n : Number , length : uint = 2 ) : String
		{
			var a : Array = n.toString().split( "." );
			var s : String = isNaN( n ) ? "" : a[ 0 ];
			
			while( s.length < length ) s = "0" + s;
			
			return s + ( a.length > 1 && !isNaN( n ) ? "." + a[ 1 ] : "" );
		}
		
		/**
		 * 求一个数的阶乘（结果可以超过Number表示范围，因此使用String返回）
		 * @param n 阶乘因数
		 * @return 结成结果
		 */		
		public static function factorial(n:int):String
		{
			var a:Array = [1];
			for(var i:int = 1; i <= n; i++)
			{
				for(var j:int = 0, c:int = 0, lenA:int = a.length; j < lenA || c != 0; j++)
				{
					var m:int = (j < lenA) ? (a[j] * i + c) : c;
					a[j] = m % 10;
					c = m * 0.1;
				}
			}
			return a.reverse().join("");
		}
		
		/**
		 * 传入一组数据，求出该组数据的和
		 * @param samples 要参与计算的数据
		 * @return 和
		 * 
		 */		
		public static function sum(samples:Array):Number
		{
			var sum:Number = 0;
			for each(var num:Number in samples)
			{
				sum += num;
			}
			return sum;
		}
		
		/**
		 * 传入一组数据，求出该组数据的平均数
		 * @param samples 要参与计算的数据
		 * @return 平均数
		 * 
		 */		
		public static function average(samples:Array):Number
		{
			return (NumberUtils.sum(samples) / samples.length);
		}
		
		/**
		 * 传入一组数据，求出该组数据的方差（每组数据出现概率按相同计算）
		 * @param samples 要参与计算的数据
		 * @return 方差值
		 */		
		public static function variance(samples:Array):Number
		{
			// 首先求出所有数据的平均数（数学期望）
			var avg:Number = NumberUtils.average(samples);
			var len:int = samples.length;
			var i:int;
			// 然后计算方差
			var variance:Number = 0;
			for(i = 0; i < len; i++)
			{
				var diff:Number = samples[i] - avg;
				variance += (diff * diff);
			}
			variance = variance / len;
			return variance;
		}
	}
}