package com.jason.stringtool
{
	public class StringTool
	{
		//-----------------------------------------------关于随机-------------------------------------------
		
		/**从26个字母中生成单个随机字母  肖建军@20141106*/
		public static function getRandomLetter():String
		{
			var result:String ;
			var randomIndex:uint = 97 + Math.floor( Math.random() * 25 ) + 1 ; 
			result = String.fromCharCode( randomIndex ) ;
			return result ;
		}
		
		/**随机排序 这个要放到库里面 肖建军@20141106 */
		private function randomArr( $arr:Array ):Array
		{
			var result:Array = $arr.slice() ;
			var len:uint = result.length;
			var temp:*;
			var indexA:int;
			var indexB:int;
			while (len)
			{
				indexA = len-1;
				indexB = Math.floor(Math.random() * len);
				len--;
				if (indexA == indexB) continue;
				temp = result[indexA];
				result[indexA] = result[indexB];
				result[indexB] = temp;
			}
			return result;
		}
		
		
		//-----------------------------------------------关于判断-------------------------------------------
		/**
		 * Test if string is a white space.
		 * @return true if string is a white space.
		 */
		public static function isWhitespace( s : String ) : Boolean
		{
			switch( s )
			{
				case " "  :
				case "\t" :
				case "\r" :
				case "\n" :
				case "\f" :
					return true;
					
				default :
					return false;
			}
		}
		
		//---------------------------------------------工具--------------------------------------
		/**
		 * Remove white spaces from string at left and right.
		 * @return a string where white spaces from left and right are removed
		 */
		public static function trim( s : String ) : String
		{
			return trimRight( trimLeft( s ) );
		}
		
		/**
		 * Remove white spaces from string at left.
		 * @return a string where white spaces from left are removed
		 */
		public static function trimLeft( s : String ) : String
		{
			s = s.replace(/^[ \t\r\n\f]+/, "");
			return s;
		}
		
		/**
		 * Remove white spaces from string at right.
		 * @return a string where white spaces from right are removed
		 */
		public static function trimRight( s : String ) : String
		{
			var end:int = s.length-1;
			while(isWhitespace(s.charAt(end)))
			{
				end--;	
			}
			return s.substr(0, end+1);			
		}
		
		/**
		 * 首字母大写
		 * @return a string with first char capitalized
		 */
		public static function capitalize( s : String ) : String
		{
			return s.charAt( 0 ).toUpperCase() + s.substr( 1 );
		}
		
		/** 
		 * 全角转半角
		 * @param str 要转换的字符串
		 * @return 转换过的字符串
		 *  */
		public static function turnedHalfAngle(str:String):String
		{
			var tmp:String = "";
			for (var i:int=0; i < str.length; i++){
				if(str.charCodeAt(i) > 65248 && str.charCodeAt(i) < 65375){
					tmp += String.fromCharCode(str.charCodeAt(i) - 65248);
				}else{
					tmp += String.fromCharCode(str.charCodeAt(i));
				}
			}
			
			return tmp;
		}
	}
}