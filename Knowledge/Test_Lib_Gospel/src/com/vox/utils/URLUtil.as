package com.vox.utils
{
	import flash.net.URLVariables;

	public class URLUtil
	{
		public function URLUtil()
		{
		}
		
		/**
		 * 解析URL参数
		 * @param $url
		 * @return 
		 */
		public static function parseParams( $url:String ):Object
		{
			var obj:Object = {};
			$url = $url.substr( $url.indexOf("?") + 1 ) ; //截取到 ? 后面的字符串 ，但不修改原始字符串.
			try
			{
				var uvs:URLVariables = new URLVariables( $url ) ;// 这个会自动调用 decode 把字符串转成 对象
			} 
			catch(error:Error) 
			{
				uvs = null ;
			}
			if( uvs )
			{
				for (var attribute:String in uvs ) 
				{
					obj[ attribute ] = uvs[ attribute ] ;	
				}
			}
			else//如果没有拿到对象，就手动把字符串解析成对象
			{
				//手动
				var arr1:Array = $url.split("&") ;
				for each (var prop:String in arr1 ) //用each时，prop就是字符串对象 
				{
					var arr2:Array = prop.split("=");
					obj[ arr2[0] ] = decodeURIComponent( arr2[1] ) ;
				}
			}
			return obj ;
		}
		
		/**
		 * 去掉多余的 "/"
		 * @param $url
		 * @return 
		 */
		public static function trim( $url:String ):String
		{
			return $url.replace(/(?<!:)\/{2,}/g, "/" ) ;
		}
		
		public static function appendParam( $url:String, $params:Object, $replace:Boolean = true ):String
		{
			var params0:Object = {};
			var index:int = $url.indexOf( "?" ) ;
			if( index >= 0 ) //如果能找到 问
			{
				var sQuery:String = $url.substr( $url.indexOf("?") + 1 ) ; //找到问号后面的部分
				$url = $url.substr( 0, index ) ;
				var aQuery:Array = sQuery.split("&") ; //问号后半部分 用 “&” 分开
				for each (var sParam:String in aQuery) 
				{
					var aParam:Array = sParam.split("=") ;// 每一个=号段，从=处分成两个元素
					params0[ aParam[ 0 ] ] = decodeURIComponent( aParam[ 1 ] ) ;
				}
			}
			
			for ( var key:String in $params )
			{
				if( !$replace && key in params0 )
				{
					continue ;
				}
				params0[ key ] = $params[ key ] ;
			}
			
			aQuery = [];
			for( key in params0 ) 
			{
				aQuery.push( key + "=" + encodeURIComponent( params0[ key ] ) ) ;
			}
			if( aQuery.length )
			{
				$url = $url + "?" + aQuery.join("&");
			}
			return $url ;
		}
		
		private static var _versionJudge:RegExp = /\d+/ ;
		//private static var _versionSplit:RegExp = /(.+)(\.[/;
	}
}