package com.vox.gospel.utils
{
	
	
	/**
	 * 对象处理工具类
	 * @author Helcarin
	 */
	public class ObjectUtil
	{
		public function ObjectUtil()
		{
			throw new Error("Do not create instance");
		}
		
		
		/**
		 * 联接两个object
		 * 1 只支持对简单类型的处理！
		 * 2 不要有循环引用！
		 * @param obj1			原对象
		 * @param obj2			新对象
		 * @param joinChild		是否联接子对象，true=递归联接，默认false=替换（如果同名）
		 * @param replace		同名属性是否替换，默认true=用obj2替换，false=保留obj1
		 */
		public static function join(obj1:Object, obj2:Object, joinChild:Boolean = false, replace:Boolean = true):void
		{
			for (var key:String in obj2)
			{
				var value2:* = obj2[key];
				if (obj1.hasOwnProperty(key))
				{
					var value1:* = obj1[key];
					if (joinChild && typeof value1 == "object" && typeof value2 == "object" && !(value1 is Array) && !(value2 is Array))
					{
						join(value1, value2, joinChild, replace);
					}
					else
					{
						if (replace)
						{
							obj1[key] = value2;
						}
					}
				}
				else
				{
					obj1[key] = value2;
				}
			}
		}
		
		
	}
}