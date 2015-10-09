package com.jason.statustool.statemachine.states
{
	import com.jason.statustool.statemachine.IState;
	import com.jason.statustool.statemachine.StateContext;
	
	/**
	 * 功能: 可以用来执行一个方法的状态，可以将方法返回值传递给下一个状态
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class FunctionState implements IState
	{
		private var _callback:Function;
		private var _thisArg:*;
		private var _args:Array;
		private var _returnValue:*;
		
		public function get skippable():Boolean
		{
			return true;
		}
		
		public function FunctionState(callback:Function, thisArg:*=null, ...args)
		{
			_callback = callback;
			_thisArg = thisArg;
			_args = args;
		}
		
		public function onAdd(context:StateContext):void
		{
		}
		
		public function onEnter(context:StateContext, data:*):void
		{
			if(_callback != null) {
				var args:Array = [context].concat(_args);
				_returnValue = _callback.apply(_thisArg, args);
			}
			context.finish(this);
		}
		
		public function onUpdate(context:StateContext, delta:int):void
		{
		}
		
		public function onPass(context:StateContext, forceFinish:Boolean):Boolean
		{
			return false;
		}
		
		public function onExit(context:StateContext):*
		{
			// 将方法返回值传递给下一个状态
			return _returnValue;
		}
		
		public function onRemove(context:StateContext):void
		{
			_returnValue = null;
		}
	}
}