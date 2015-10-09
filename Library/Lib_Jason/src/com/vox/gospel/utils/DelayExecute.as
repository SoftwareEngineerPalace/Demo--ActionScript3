package com.vox.gospel.utils
{
	

	/**
	 * 功能: 延迟执行工具，可以将要执行的方法和属性暂存在这里，之后某个时刻一次性按顺序执行
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class DelayExecute
	{
		private var _executeQueue:Vector.<ExecuteQueueValue>;
		
		public function DelayExecute()
		{
			_executeQueue = new Vector.<ExecuteQueueValue>();
		}
		
		/**
		 * 暂存一个需要执行的方法
		 * @param target 针对的对象
		 * @param funcOrName 要执行的方法引用或方法名
		 * @param args 方法中要传入的参数
		 */		
		public function exeFunction(target:Object, funcOrName:*, ...args):void
		{
			if(target == null || funcOrName == null || funcOrName == "") return;
			var data:ExecuteQueueValue = new ExecuteQueueValue();
			data.target = target;
			data.funcOrName = funcOrName;
			data.args = args;
			_executeQueue.push(data);
		}
		
		/**
		 * 暂存一个赋值操作，如果之前已经存在对同一个值的赋值操作，则会直接覆盖之前的操作，防止执行操作过多而卡死
		 * @param target 针对的对象
		 * @param name 要赋值的对象名
		 * @param value 要赋的值
		 */		
		public function setVariable(target:Object, name:String, value:*):void
		{
			if(target == null || name == null || name == "") return;
			var data:ExecuteQueueValue;
			for(var i:int = 0, len:int = _executeQueue.length; i < len; i++)
			{
				data = _executeQueue[i];
				if(data.target == target && data.varName == name)
				{
					_executeQueue.splice(i, 1);
					data.value = value;
					_executeQueue.push(data);
					return;
				}
			}
			data = new ExecuteQueueValue();
			data.target = target;
			data.varName = name;
			data.value = value;
			_executeQueue.push(data);
		}
		
		/**
		 * 执行之前暂存的所有方法和属性赋值
		 */		
		public function execute():void
		{
			for(var i:int = 0, len:int = _executeQueue.length; i < len; i++)
			{
				var data:ExecuteQueueValue = _executeQueue.shift();
				try
				{
					if(data.funcOrName != null)
					{
						// 执行方法
						var func:Function;
						if(data.funcOrName is Function)
						{
							func = data.funcOrName;
							func.apply(data.target, data.args);
						}
						else if(data.funcOrName is String && data.target.hasOwnProperty(data.funcOrName))
						{
							func = data.target[data.funcOrName] as Function;
							if(func != null) func.apply(data.target, data.args);
						}
					}
					else
					{
						// 赋值属性
						if(data.target.hasOwnProperty(data.varName))
						{
							data.target[data.varName] = data.value;
						}
					}
				} 
				catch(error:Error) 
				{
				}
			}
		}
		
		/**
		 * 直接清理掉所有暂存操作，但不执行
		 */		
		public function clear():void
		{
			_executeQueue = new Vector.<ExecuteQueueValue>();
		}
		
		/**
		 * 销毁这个对象
		 */		
		public function dispose():void
		{
			_executeQueue = null;
		}
	}
}

class ExecuteQueueValue
{
	public var target:Object;
	
	public var funcOrName:*;
	public var args:Array;
	
	public var varName:String;
	public var value:*;
}