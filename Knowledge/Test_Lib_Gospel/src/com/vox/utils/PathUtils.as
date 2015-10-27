package com.vox.utils
{
	import flash.events.ErrorEvent;

	public class PathUtils
	{
		private static var _parameters:Object ;
		private static var _changeImgDomainCallbacks:Vector.<Function> = new Vector.<Function>();
		
		public function PathUtils()
		{
		}
		
		/**
		 * 防止导入过多类定义，如需使用该类需初始化之，这样可以让该类使用更独立.
		 * @param $parameters
		 */
		public function initialize( $parameters:Object ):void
		{
			_parameters = $parameters ;
		}
		
		public function wrapFlashURL( $path:String ):void
		{
			var swfPath:String = wrapRelativeSwfPath( $path ) as String ;
			var imgURL:String = wrapImgDomain( swfPath ) ;
			return imgURL ;
		}
		
		/**
		 * 将相对路径    包装为  相对flash路径
		 * @param $path
		 * @return 
		 */
		public static function wrapRelativeSwfPath( $path:String ):String
		{
			return "resources/apps/flash/" + $path ;
		}
		
		public static function wrapDomain( $path:String ):String
		{
			var result:String = "";
			try
			{
				var domain:String = _parameters.domain ;
				result = domain + "/" + $path ;
			} 
			catch(error:Error) 
			{
				
			}
			return result ;
		}
		
		public static function wrapImgDomain( $path:String ):String
		{
			var result:String = "";
			try
			{
				var imgDomain:String = _parameters.imgDomain ;
				if( imgDomain == null ) imgDomain = _parameters.imgDomain ;
				result = imgDomain + "/" + $path ;
			} 
			catch(error:Error) 
			{
				
			}
			return result ;
		}
		
		public static function changeImgDomain( $callBack:Function ):void
		{
			_changeImgDomainCallbacks.push( $callBack ) ;
			if( _changeImgDomainCallbacks.length > 1 ) return ;
			
			var url:String = PathUtils.wrapDomain("changeimgdomain.vpage");
			LoadUtil.urlLoaderLoad( url, changeImgdomainSucessfulCbk, changeImgdomainFailCbk ) ;
		}
		
		private static function changeImgdomainFailCbk( $evt:ErrorEvent ):void
		{
			callAll( null ) ;
		}
			
		
		private static function changeImgdomainSucessfulCbk( $str:String ):void
		{
			var data:Object = JSON.parse( $str ) ;
			if( !data.success )
			{
				callAll( null ) ;
			}
			else
			{
				var imgDomain:String = data.imgDomain ;
				_parameters.imgDomain = imgDomain ; //这是最关键的一步. 把获得的imgDomain存下来
				callAll( imgDomain ) ;
			}
		}
		
		private static function callAll( $imgDomain:String ):void
		{
			for (var i:int = 0, len:uint = _changeImgDomainCallbacks.length; i < len; i++ ) 
			{
				var cbk:Function = _changeImgDomainCallbacks.shift() ;
				if( cbk != null )
				{
					cbk( $imgDomain ) ;
				}
			}
		}
	}
}