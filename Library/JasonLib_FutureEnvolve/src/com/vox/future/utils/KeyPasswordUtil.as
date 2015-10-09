package com.vox.future.utils
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 * 功能: 该类用来做背景密码操作
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class KeyPasswordUtil
	{
		private static var _stage:Stage;
		
		private static var _passDict:Object = {};
		private static var _curPass:String = "";
		private static var _argDict:Dictionary = new Dictionary();
		
		/**
		 * 防止导入过多类定义，如需使用该类需初始化之，这样可以让该类使用更独立
		 * @param stage 舞台引用
		 */		
		public static function initialize(stage:Stage):void
		{
			_stage = stage;
		}
		
		/**
		 * 添加密码映射
		 * @param password 密码字符串
		 * @param callback 当输入了密码字符串后调用的回调方法
		 * @param args 传递给callback的参数
		 */		
		public static function addMap(password:String, callback:Function, ...args):void
		{
			if(password == null || password == "") return;
			var callbacks:Array = _passDict[password];
			if(callbacks == null)
			{
				callbacks = [];
				_passDict[password] = callbacks;
			}
			if(callbacks.indexOf(callback) >= 0) return;
			callbacks.push(callback);
			_argDict[callback] = args;
			updateListeners();
		}
		
		/**
		 * 移除密码映射
		 * @param password 密码字符串
		 * @param callback 当输入了密码字符串后调用的回调方法
		 */		
		public static function removeMap(password:String, callback:Function):void
		{
			if(password == null || password == "") return;
			var callbacks:Array = _passDict[password];
			if(callbacks == null) return;
			var index:int = callbacks.indexOf(callback);
			if(index < 0) return;
			callbacks.splice(index, 1);
			delete _argDict[callback];
			if(callbacks.length == 0)
			{
				delete _passDict[password];
			}
			updateListeners();
		}
		
		private static function updateListeners():void
		{
			var hasMap:Boolean = false;
			for(var password:String in _passDict)
			{
				var callbacks:Array = _passDict[password];
				if(callbacks != null && callbacks.length > 0)
				{
					hasMap = true;
					break;
				}
			}
			// 有密码则监听事件，没有则取消事件
			if(hasMap)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			else
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
		private static function onKeyDown(event:KeyboardEvent):void
		{
			var charCode:uint = event.charCode;
			if(charCode == 0) return;
			var char:String = String.fromCharCode(charCode);
			_curPass += char;
			var curPassLen:int = _curPass.length;
			var firstIndex:int = -1;
			for(var password:String in _passDict)
			{
				var passwordLen:int = password.length;
				// 首先找出所有与当前字符匹配的password索引
				var curIndex:int = passwordLen - 1;
				while(curIndex >= 0)
				{
					var tempIndex:int = password.lastIndexOf(char, curIndex);
					curIndex = tempIndex - 1;
					if(tempIndex >= 0)
					{
						// 找到一个，从后往前判断是否相等，如果把password判断完都相等说明当前输入的序列是部分重合的
						var equal:Boolean = true;
						for(var i:int = tempIndex - 1; i >= 0; i--)
						{
							if(password.charAt(i) != _curPass.charAt(curPassLen - 1 - (tempIndex - i)))
							{
								equal = false;
								break;
							}
						}
						if(equal)
						{
							// 判断是否是全部重合
							if(tempIndex == passwordLen - 1)
							{
								// 全部重合，触发回调
								var callbacks:Array = _passDict[password];
								for each(var callback:Function in callbacks)
								{
									var args:Array = _argDict[callback];
									callback.apply(null, args);
								}
							}
							else
							{
								// 部分重合，要记录最早重合的索引
								var tempFirstIndex:int = curPassLen - 1 - tempIndex;
								if(tempFirstIndex < firstIndex)
								{
									firstIndex = tempFirstIndex;
								}
							}
						}
					}
				}
			}
			// 最后要截取现有字符串，防止超长
			if(firstIndex > 0)
			{
				_curPass = _curPass.substr(firstIndex);
			}
		}
	}
}