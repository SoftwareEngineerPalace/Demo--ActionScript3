package com.vox.gospel.utils
{
	import com.adobe.crypto.MD5;
	
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.StringUtil;
	
	public class MathUtils
	{
		private static var _root:String = "";
		/** 接口地址，默认空串 */
		public static function get root():String
		{
			return _root;
		}
		public static function set root(value:String):void
		{
			if (value)
			{
				_root = value;
				if (_root.charAt(_root.length-1) != "/" )
				{
					_root = _root + "/";
				}
			}
			else
			{
				_root = "";
			}
		}
		
		
		/** 默认使用的版本号，默认1 */
		public static var defaultVersion:int = 1;
		
		/** 默认大小，默认128 */
		public static var defaultDensity:int = 128;
		
		/** 默认后缀，默认空串 */
		public static var defaultSuffix:String = "";
		
		
		public function MathUtils()
		{
		}
		
		
		/**
		 * 将latex文本编码成对应的url地址的通用方法
		 * @param latex 	LaTeX格式的公式文本
		 * @param density 	像素密度，越高生成的图片越大，默认defaultDensity
		 * @param ver 		版本，默认为defaultVersion
		 * @param suffix 	后缀，默认为defaultSuffix
		 */
		public static function latex2URL(latex:String, density:uint = 0xffffffff, ver:uint = 0xffffffff, suffix:String = null):String
		{
			if (density === 0xffffffff) density = defaultDensity;
			if (ver === 0xffffffff) ver = defaultVersion;
			
			var url:String = latex2Base64(latex);
			url = [root, ver, "-", url, "-", density, (suffix || defaultSuffix)].join("");
			
			return url;
		}
		
		
		/**
		 * 对latex文本进行base64编码
		 */
		public static function latex2Base64(latex:String):String
		{
			if (!latex) latex = "";
			
			// 去除空格
			latex = mx.utils.StringUtil.trim(latex);
			
			// 去除首尾的"$"
			if (latex.charAt(0) == '$' && latex.charAt(latex.length - 1) == '$')
			{
				latex = latex.substr(1, latex.length - 2);
				latex = mx.utils.StringUtil.trim(latex);
			}
			
			// 进行base64编码
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.insertNewLines = false;
			encoder.encodeUTFBytes(latex);
			var str:String = encoder.toString();
			// 替换base64字符
			str = str.replace(/\+/g, "~");
			str = str.replace(/\//g, "!");
			str = str.replace(/=/g, "");
			return str;
		}
		
		
		/**
		 * 对latex反编码
		 * @param url	编码后的url，至少应包含base64后的部分
		 * @return		解码后的latex
		 */
		public static function decode(url:String):String
		{
			// 去除host，path，query
			var a:Array = url.split("/");
			var s:String = a[a.length - 1] || "";
			s = s.split("?", 2)[0];
			
			// 去除后缀
			s = s.split(".", 2)[0];
			
			// 去除ver和density
			a = s.split("-", 3);
			if (a.length > 2)
			{
				s = a[1];
			}
			
			// 替换base64字符
			s = s.replace("~", "+");
			s = s.replace("!", "/");
			for (var i:int = s.length % 4; i > 0 && i < 4; i++)
			{
				s += '=';
			}
			
			// 进行base64解码
			try
			{
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(s);
				var b:ByteArray = decoder.toByteArray();
				b.position = 0;
				s = b.readUTFBytes(b.length);
			}
			catch(err:Error) {
				s = "";
			}
			
			return s;
		}
		
		
		/**
		 * <font color="#a00000"><b>已过期</b></font>
		 * <br>将latex文本编码成对应的接口url
		 * <br>应试专用，新应用请使用通用方法
		 */
		public static function transLaTeXToURL(latex:String):String
		{
			var url:String = latex2URL(latex, 0, 0);
			url += ".png";
			var md5:String = MD5.hash(url + ".latex").substring(0, 4);
			var path:String = [md5.substr(0, 2), md5.substr(2, 2), url].join("/");
			return path;
		}
		
		/**
		 * 将输入参数向上调整为2的幂次
		 * @param input 输入参数
		 * @return 输出参数
		 */		
		public static function ceilToPow2(input:Number):Number
		{
			return Math.pow(2, Math.ceil(Math.log(input) * Math.LOG2E));
		}
		
	}
}