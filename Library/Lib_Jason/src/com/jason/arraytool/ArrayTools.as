package com.jason.arraytool
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ArrayTools
	{
		//-----------------------------增加-----------------------------------
		
		
		
		//-----------------------------删除-----------------------------------
		/**
		 * 清除数组重复，使数组元素保持唯一
		 * <br>
		 * updated by yifan.zhang at 2014.09.04
		 * 保持原顺序
		 * <br>
		 * @param array
		 * @return 
		 */		
		public static function unique(array:Array):Array
		{
			var result:Array = [];
			var valueSet:Dictionary = new Dictionary(true);
			var length:int = array.length;
			var index:int = 0;
			for(var i:int = 0; i < length; i++)
			{
				var item:* = array[i];
				if (!(item in valueSet))
				{
					result[index++] = item;
					valueSet[item] = true;
				}
			}
			return result;
		}
		
		
		/**
		 * 删除数组中某个对象或值 
		 * @param arr 数组对象
		 * @param value 要删除的值
		 */		
		public static function removeValueFromArray(arr : *, value : Object) : void
		{
			var len : uint = arr.length - 1;
			
			for (var i : int = len; i >= 0; i--) {
				if (arr[i] === value) {
					arr.splice(i, 1);
				}
			}
		}
		
		/**
		 * 删除arr1中含有arr2对象的值
		 * @param arr1
		 * @param arr2
		 * @return 
		 */		
		public static function cleanMerge(arr1 : Array, arr2 : Array) : Array
		{
			var result : Array = [];
			if(arr1 && arr2) {
				for each(var value : * in arr1) {
					if(arr2.indexOf(value) != -1) {
						result.push(value);
					}
				}
			}
			return result;
		}
		
		
		
		//-----------------------------更新-----------------------------------
		/**
		 * 交换数组中2个元素 
		 * @param aArray
		 * @param nIndexA 第一个元素的序号
		 * @param nIndexB 第二个元素的序号
		 */	
		public static function switchElements2(aArray:Array, nIndexA:Number, nIndexB:Number):void 
		{
			var t:* = aArray[nIndexA];
			aArray[nIndexA] = aArray[nIndexB];
			aArray[nIndexB] = t;
		}
		
		
		
		//------------------------------查询----------------------------------
		/**
		 * 找出相等的数组元素索引
		 * //为毛要用不定个数的参数 
		 * @param aArray
		 * @param oElement
		 * @param ...rest
		 * @return 
		 */		
		public static function findMatchIndex(aArray:Array, oElement:Object, ...rest):Number 
		{
			var nStartingIndex:Number = 0;
			var bPartialMatch:Boolean = false;
			if(typeof rest[0] == "number") 
			{
				nStartingIndex = rest[0];
			}    
			else if(typeof rest[1] == "number") 
			{
				nStartingIndex = rest[1];
			}
			if(typeof rest[0] == "boolean") 
			{
				bPartialMatch = rest[0];
			}
			var bMatch:Boolean = false;
			for(var i:Number = nStartingIndex; i < aArray.length; i++) 
			{
				if(bPartialMatch) 
				{
					bMatch = (aArray[i].indexOf(oElement) != -1);
				}
				else
				{
					bMatch = (aArray[i] == oElement);
				}
				if(bMatch)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 返回数组最小值（元素会强制转换成Number，若出现NaN则最终结果为NaN） 
		 * @param aArray
		 * @return 
		 */	
		public static function min(aArray:Array):Number 
		{
			return Math.min.apply(null, aArray);
		}
		
		
		/**
		 * 返回数组最大值（元素会强制转换成Number，若出现NaN则最终结果为NaN） 
		 * @param aArray
		 * @return 
		 */	
		public static function max(aArray:Array):Number 
		{
			return Math.max.apply(null, aArray);
		}
		
		
		/**
		 * 从数组指定范围内随机取出指定数量的不重复元素
		 * <listing version="3.0">
		 * ArrayUtils.randomize([0,1,2,3,4,5,6,7,8,9], 3, 2, 7);
		 * //返回[6,2,3]
		 * </listing>
		 * @param $arr 		原始数组（可以是Vector，但返回值总是Array）
		 * @param $count	数量，默认为范围内全部元素 
		 * @param $begin 	起始位置，默认为0
		 * @param $end		结束位置，默认为数组长度
		 * @return			随机取出的数组
		 * @author Helcarin
		 */
		public static function randomize($arr:*, $count:int=-1, $begin:int=0, $end:int=-1):Array
		{
			if (!$arr || $begin<0) throw new ArgumentError();
			
			$arr = $arr.concat();
			var len:int = $arr.length;
			if ($end<1 || $end>len) $end=len;
			if ($count<1 || $count>$end-$begin) $count=$end-$begin;
			
			var arr2:Array = [];
			var end2:int = $begin+$count;
			for(var i:int=$begin; i<end2; i++)
			{
				var index:int = int(Math.random()*($end-i)+i);
				arr2[i-$begin] = $arr[index];
				$arr[index] = $arr[i];
			}
			
			return arr2;
		}
		
		/**
		 * 通过某个属性找到存在该属性对象的索引 
		 * @param _arr 目标数组
		 * @param _attri 对象元素的某个key
		 * @param _value 对象元素的某个key对应的value
		 * @return 
		 */		
		public static function indexByAttr(_arr : Array, _attri : String, _value : *) : int
		{
			for (var i:int = _arr.length - 1; i >= 0; i--)
			{
				if (_arr[i][_attri] == _value)
				{
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 通过某个属性找到数组中存在该属性的对象
		 * @param _arr 目标数组
		 * @param _attri 对象元素的某个key
		 * @param _value 对象元素的某个key对应的value
		 * @return 
		 */		
		public static function findByAttr(_arr : Array, _attri : String, _value : *) : Object
		{
			var _i : int = indexByAttr(_arr, _attri, _value);
			if (_i != -1) {
				return _arr[_i];
			}
			return null;
		}
		
		
		
		//-----------------------------------------计算----------------------------------------------
		/**
		 * 计算数组中数值的和（非number类型的元素会被忽略） 
		 * @param aArray
		 * @return 
		 */	
		public static function sum(aArray:Array):Number 
		{
			var nSum:Number = 0;
			for(var i:int = aArray.length - 1; i >= 0; i--) 
			{
				if(typeof aArray[i] == "number") 
				{
					nSum += aArray[i];
				}
			}
			return nSum;
		}
		
		/**
		 * 计算数组中数值的平均值 
		 * @param aArray
		 * @return 
		 */	
		public static function average(aArray:Array):Number 
		{
			return sum(aArray) / aArray.length;
		}
		
		
		//-----------------------------------------判断-----------------------------------------------
		
		/**
		 * 判断两个数组是否全等 肖建军@2015-06-11 
		 * @param aArrayA
		 * @param aArrayB
		 * @param bNotOrdered
		 * @param bRecursive
		 * @return 
		 */
		public static function equals(aArrayA:Array, aArrayB:Array, bNotOrdered:Boolean, bRecursive:Boolean):Boolean 
		{
			if(aArrayA.length != aArrayB.length) 
			{
				return false;
			}
			var aArrayACopy:Array = aArrayA.concat();
			var aArrayBCopy:Array = aArrayB.concat();
			if(bNotOrdered) 
			{
				aArrayACopy.sort();
				aArrayBCopy.sort();
			}
			for(var i:Number = 0; i < aArrayACopy.length; i++) 
			{
				if(aArrayACopy[i] is Array && bRecursive) 
				{
					if(!equals(aArrayACopy[i], aArrayBCopy[i], bNotOrdered, bRecursive)) 
					{
						return false;
					}
				}
				else if(aArrayACopy[i] is Object && bRecursive) 
				{
					if(!objectEquals(aArrayACopy[i], aArrayBCopy[i])) 
					{
						return false;
					}
				}
				else if(aArrayACopy[i] != aArrayBCopy[i]) 
				{
					return false;
				}
			}
			return true;
		}
		
		
		/**
		 * 判断数组中2个对象是否相等 
		 * @param oInstanceA
		 * @param oInstanceB
		 * @return 
		 */	
		public static function objectEquals(oInstanceA:Object, oInstanceB:Object):Boolean 
		{
			for(var sItem:String in oInstanceA) 
			{
				if(oInstanceA[sItem] is Object) 
				{
					if(!objectEquals(oInstanceA[sItem], oInstanceB[sItem])) 
					{
						return false;
					}
				}
				else
				{
					if(oInstanceA[sItem] != oInstanceB[sItem]) 
					{
						return false;
					}
				}
			}
			return true;
		}
		
		//-----------------------------------------------工具-----------------------------------------public static function duplicate(oArray:Object, bRecursive:Boolean = false):Object 
		/**
		 * 复制对象
		 * @param oArray
		 * @param bRecursive
		 * @return 
		 */
		public static function duplicate(oArray:Object, bRecursive:Boolean = false):Object 
		{
			var oDuplicate:Object;
			if(bRecursive) 
			{
				if(oArray is Array) 
				{
					oDuplicate = [];
					for(var i:Number = 0; i < oArray.length; i++) 
					{
						if(oArray[i] is Object) 
						{
							oDuplicate[i] = duplicate(oArray[i]);
						}
						else 
						{
							oDuplicate[i] = oArray[i];
						}
					}
					return oDuplicate;
				}
				else 
				{
					var oDuplicate4:Object = new Object();
					for(var sItem:String in oArray) 
					{
						if(oArray[sItem] is Object && !(oArray[sItem] is String) &&
							!(oArray[sItem] is Boolean) && !(oArray[sItem] is Number)) 
						{
							oDuplicate4[sItem] = duplicate(oArray[sItem], bRecursive);
						}
						else 
						{
							oDuplicate4[sItem] = oArray[sItem];
						}
					}
					return oDuplicate4;
				}
			}
			else 
			{
				if(oArray is Array) 
				{
					return oArray.concat();
				}
				else 
				{
					var oDuplicate5:Object = new Object();
					for(var sItem2:String in oArray) 
					{
						oDuplicate5[sItem2] = oArray[sItem2];
					}
					return oDuplicate5;
				}
			}
		}
		
		/**
		 * 对象字符串打印输出 
		 * @param oArray
		 * @param nLevel
		 * @return 
		 */		
		public static function toString(oArray:Object, nLevel:uint = 0):String 
		{
			var sIndent:String = "";
			for(var i:Number = 0; i < nLevel; i++)
			{
				sIndent += "\t";
			}
			var sOutput:String = "";
			for(var sItem:String in oArray)
			{
				if(oArray[sItem] is Object) 
				{
					sOutput = sIndent + "** " + sItem + " **\n" + toString(oArray[sItem], nLevel + 1) + sOutput;
				}
				else 
				{
					sOutput += sIndent + sItem + ":" + oArray[sItem] + "\n";
				}
			}
			return sOutput;
		}
		
		/**
		 * 数组打乱重排
		 * @param source The array to shuffle.
		 * @return The shuffled Array.
		 */
		public static function shuffle( source : Array ) : Array
		{
			if( source == null ) return null;
			
			return source.sort( function( ...arguments : Array ) : int { return Math.round( Math.random() * 2 ) - 1; } );
		}
		
		/**
		 * 深度复制一个对象
		 * @param value
		 * @return 
		 */		
		public static function copy(value:Object):Object
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result:Object = buffer.readObject();
			return result;
		}
		
		
	}
}