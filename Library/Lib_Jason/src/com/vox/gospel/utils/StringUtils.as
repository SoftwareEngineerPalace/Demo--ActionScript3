/*
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at 
 *
 *        http://www.mozilla.org/MPL/ 
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the License. 
 *
 * The Original Code is myLib.
 *
 * The Initial Developer of the Original Code is
 * Samuel EMINET (aka SamYStudiO) contact@samystudio.net.
 * Portions created by the Initial Developer are Copyright (C) 2008-2011
 * the Initial Developer. All Rights Reserved.
 *
 */
package com.vox.gospel.utils{
	/**
	 * Utils for String operations.
	 * 
	 * @author SamYStudiO (contact&#64;samystudio.net)
	 * <br>
	 * modified by Helcarin
	 */
	public final class StringUtils 	{
		/**
		 * @private
		 */
		public function StringUtils()
		{
			throw new Error( this + " cannot be instantiated" );
		}
		
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
		 * Capitalize first char from specified string
		 * @return a string with first char capitalized
		 */
		public static function capitalize( s : String ) : String
		{
			return s.charAt( 0 ).toUpperCase() + s.substr( 1 );
		}
		
		/**
		 * Test if string is a valid email.
		 * @return true if string is a valid email.
		 */
		public static function isEmail( s : String ) : Boolean
		{
			return /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i.test( s );
		}
		
		public static function replaceAll(str:String=null, fnd:String=null, rpl:String=null):String 
		{
			if(str)
			{
				return str.split(fnd).join(rpl);
			}
			else{
				return "";
			}
		}
		
		/**
		 * 获取前缀
		 * @param str 要查询的字符串
		 * @param separator 分隔符
		 * @return 前缀，如果未找到返回""
		 */
		public static function getPrefix(str:String, separator:String):String
		{
			var index:int = str.indexOf(separator);
			if (index >= 0) return str.substr(0, index);
			else return "";
		}
		
		/**
		 * 是否由给定字符串起始
		 * @param str 要查询的字符串
		 * @param prefix 前缀
		 * @return 是否由该prefix起始
		 */
		public static function startWith(str:String, prefix:String):Boolean
		{
			return str.lastIndexOf(prefix, 0) == 0;
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
		
		/** 
		 * 过滤掉！？，。'-空格（包含英文下，中文下和全角下）
		 * @param str 要过滤的字符串
		 * @return 过滤了的字符串
		 *  */
		public static function stringFilter(str:String):String
		{
			str = str.toLowerCase().replace(/[,，!！'‘’.。:：?？＇．\-－  　]/g,"");
			return str;
		}
	}
}
