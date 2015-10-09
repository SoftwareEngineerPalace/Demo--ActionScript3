package com.vox.gospel.utils
{
	public final class RegExpUtils
	{
		
		/**
		 * 常用正则表达式
		 * 
		 * 使用方法举例：
		 * <br>
		 * RegExpUtils.NONE_NEGATIVE_INTEGER.test("xxxxxxxxxxxxx");
		 * 
		 * @return boolean
		 */
		
		public function RegExpUtils()
		{
			throw new Error( this + " cannot be instantiated" );
		}
		
		/**匹配非负整数（正整数 + 0）*/
		public static const NONE_NEGATIVE_INTEGER:RegExp = /^\d+$/;
		
		/**匹配正整数 */
		public static const POSITIVE_INTEGER:RegExp = /^[0-9]*[1-9][0-9]*$/;
		
		/**匹配非正整数（负整数 + 0）*/
		public static const NONE_POSITIVE_INTEGER:RegExp = /^((-\d+)|(0+))$/;
		
		/**匹配负整数 */
		public static const NEGATIVE_INTEGER:RegExp = /^-[0-9]*[1-9][0-9]*$/;
		
		/**匹配整数 */
		public static const INTEGER:RegExp = /^-?\d+$/;
		
		/**匹配非负浮点数（正浮点数 + 0） */
		public static const NONE_NEGATIVE_FLOAT:RegExp = /^\d+(\.\d+)?$/;
		
		/**匹配正浮点数 */
		public static const POSITIVE_FLOAT:RegExp = /^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$/;
		
		/**匹配非正浮点数（负浮点数 + 0） */
		public static const NONE_POSITIVE_FLOAT:RegExp =	/^((-\d+(\.\d+)?)|(0+(\.0+)?))$/;
		
		/**匹配负浮点数 */
		public static const NEGATIVE_FLOAT:RegExp =	/^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/;
		
		/**匹配浮点数 */
		public static const FLOAT:RegExp =	 /^(-?\d+)(\.\d+)?$/;
		
		/**匹配由26个英文字母组成的字符串 */
		public static const LETTER_STRING:RegExp = /^[A-Za-z]+$/;
		
		/**匹配由26个英文字母的大写组成的字符串 */
		public static const CAPITAL_LETTER_STRING:RegExp = /^[A-Z]+$/;
		
		/**匹配由26个英文字母的小写组成的字符串 */
		public static const LOWERCASE_LETTER_STRING:RegExp = /^[a-z]+$/;
		
		/**匹配由数字和26个英文字母组成的字符串 */
		public static const INTEGER_LETTER_STRING:RegExp = /^[A-Za-z0-9]+$/;
		
		/**匹配由数字、26个英文字母或者下划线组成的字符串 */
		public static const INTEGER_LETTER_UNDERLINE_STRING:RegExp = /^\w+$/;
		
		/**匹配email地址 */
		public static const EMAIL:RegExp =/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
		
		/**匹配url */
		public static const URL:RegExp = /^[a-zA-Z]+:\/\/(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$/;
		
		/**匹配中文字符的正则表达式*/
		public static const CHINESE_CHARACTER:RegExp = /[\u4e00-\u9fa5] /;
		
		/**匹配双字节字符(包括汉字在内)*/
		public static const DOUBLE_BYTE_CHARACTER:RegExp = /[^\x00-\xff] /;
		
		/**匹配HTML标记的正则表达式*/
		public static const HTML_TAG:RegExp = /<(.*)>.*<\/>|<(.*) \/>/;
		
		/**匹配首尾空格的正则表达式*/
		public static const BLANK_HEAD_TAIL_TAG:RegExp = /(^\s*)|(\s*$)/;
		
		/**匹配帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线)*/
		public static const LEGAL_ACCOUNT:RegExp =  /^[a-zA-Z][a-zA-Z0-9_]{4,15}$/;
		
		/**匹配国内电话号码*/
		public static const CHINESE_TELEPHONE_NO:RegExp =  /(\d{3}-|\d{4}-)?(\d{8}|\d{7})?/;
		
		/**配腾讯QQ号*/
		public static const TENCENT_QQ:RegExp =  /^[1-9]*[1-9][0-9]*$/;
		
		
		/** 两位16进制 */
		public static const HEX:RegExp = /^(?:[0-9a-fA-F]{2})+$/;
		
	}
}