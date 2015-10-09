package com.jason.statustool.statemachine
{
	import flash.utils.setTimeout;
	
	/**
	 * 功能: 状态机一个生命周期内的上下文
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class StateContext
	{
		private var _userData:Object = {};
		private var _stateMachine:StateMachine;
		
		/** 获取或设置是否跳过剩余可跳过的状态 */
		public var skip:Boolean = false;
		
		/** 在一个状态机生命周期中可以保存任意数据，状态机生命周期结束后将被销毁 */
		public function get userData():Object {return _userData;}
		/** 获取或设置状态机自动运行状态 */
		public function get autoRun():Boolean {return _stateMachine.autoRun;}
		public function set autoRun(value:Boolean):void {_stateMachine.autoRun = value;}
		
		public function StateContext(stateMachine:StateMachine)
		{
			_stateMachine = stateMachine;
		}
		
		/**
		 * 添加一个或多个状态到当前状态机，该方法为状态提供在运行时动态增加状态机状态的机会
		 * @param state 要添加的状态
		 * @param more 可能要添加的更多状态
		 * @return 返回当前状态数量
		 */		
		public function addState(state:IState, ...more):uint {
			more.unshift(state);
			return _stateMachine.add.apply(_stateMachine, more);
		}
		
		/**
		 * 当需要结束状态时调用该方法即可
		 * @param state 要结束的状态，必须与当前状态吻合才会奏效。如果传递null则默认是结束当前状态（慎用）
		 */		
		public function finish(state:IState=null):void {
			// 之所以要用setTimeout，是因为防止堆栈溢出
			setTimeout(_stateMachine.shift, 0, state);
		}
		
		/** 清理状态机上下文对象 */
		internal function clear():void {
			for(var key:* in _userData) {
				delete _userData[key];
			}
		}
	}
}