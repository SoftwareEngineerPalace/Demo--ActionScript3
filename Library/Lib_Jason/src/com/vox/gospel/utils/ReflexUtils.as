package com.vox.gospel.utils
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class ReflexUtils
	{
		
		/**
		 * 是否是继承或实现
		 * @param cls1 类
		 * @param cls2 类或接口
		 */
		public static function isInheritOrImplement(cls1:Class, cls2:Class):Boolean
		{
			return isInherit(cls1, cls2) || isImplement(cls1, cls2);
		}
		
		
		/**
		 * cls1是否是类cls2的继承
		 * @param cls1 类
		 * @param cls2 类
		 */
		public static function isInherit(cls1:Class, cls2:Class):Boolean
		{
			var className:String = getQualifiedClassName(cls1);
			
			while (className != null)
			{
				var superCls:Class = getDefinitionByName(className) as Class;
				if (superCls == cls2) return true;
				className = getQualifiedSuperclassName(superCls);
			}
			
			return false;
		}
		
		/**
		 * cls1是否是接口cls2的实现
		 * @param cls1 类
		 * @param cls2 接口
		 */
		public static function isImplement(cls1:Class, cls2:Class):Boolean
		{
			var desc:XML = getDescribe(cls1);
			return (desc.factory.implementsInterface.(@type == getQualifiedClassName(cls2)).length() != 0);
		}
		
		
		/**
		 * 是否是Vector
		 * @param obj 类或实例
		 */
		public static function isVector(obj:*):Boolean
		{
			// TODO
			return false;
		}
		
		
		/** describeType的缓存 */
		private static var describeTypeCache:Dictionary = new Dictionary(true); 
		/** 带缓存的describeType */
		public static function getDescribe(target:*):XML
		{
			if (describeTypeCache[target]) return describeTypeCache[target];
			var data:XML = describeType(target);
			describeTypeCache[target] = data;
			return data;
		}
		
		
		public function ReflexUtils()
		{
		}
	}
}