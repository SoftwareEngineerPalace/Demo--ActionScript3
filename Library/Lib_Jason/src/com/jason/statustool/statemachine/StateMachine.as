package com.jason.statustool.statemachine
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import ghostcat.manager.RootManager;
	
	/**
	 * 功能: 状态机
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class StateMachine
	{
		private var _states:Vector.<IState> = new Vector.<IState>();
		private var _context:StateContext;
		private var _running:Boolean = false;
		private var _pause:Boolean = false;
		private var _pauseData:* = null;
		private var _tempUserData:Object = {};
		
		/** 是否在添加状态时自动立即运行状态机，默认为false */
		public var autoRun:Boolean = false;
		
		/** 获取状态机当前是否正在运行 */
		public function get running():Boolean
		{
			return _running;
		}
		
		/** 获取用户数据，可以修改其中的值，这些值在状态机一次生命周期中会一直奏效 */
		public function get userData():Object
		{
			return _context.userData;
		}
		
		public function StateMachine()
		{
			_context = new StateContext(this);
		}
		
		private function onUpdate(delta:int):void
		{
			// 调用当前状态的onUpdate方法，并把毫秒间隔传递过去
			_states[0].onUpdate(_context, delta);
		}
		
		public function addUserData(key:*, value:*):void
		{
			if(_context != null) _context.userData[key] = value;
			else _tempUserData[key] = value;
		}
		
		/**
		 * 添加一个或多个状态
		 * @param state 要添加的状态
		 * @param more 可能要添加的更多状态
		 * @return 返回当前状态数量
		 */		
		public function add(state:IState, ...more):uint
		{
			more.unshift(state);
			for(var i:int = 0, len:int = more.length; i < len; i++) {
				var temp:IState = more[i] as IState;
				if(temp != null) {
					_states.push(temp);
					temp.onAdd(_context);
				}
			}
			if(_pause && autoRun) this.resume();
			return _states.length;
		}
		
		/**
		 * 弹出当前的状态
		 * @param state 要结束的状态，必须与当前状态吻合才会奏效。如果传递null则默认是结束当前状态（慎用）
		 * @return 弹出的状态
		 */		
		public function shift(state:IState=null):IState
		{
			if(_states.length == 0) return null;
			var stateExit:IState = _states[0];
			if(state != null && stateExit != state) return null;
			// 调用onExit方法，获得传递给下一个状态的参数
			var data:* = stateExit.onExit(_context);
			// 调用onRemove方法，并且将该状态移除掉
			stateExit.onRemove(_context);
			_states.shift();
			
			if(_pause) {
				// 如果有暂停，则暂时停止执行下一个状态
				_pauseData = data;
			} else if(_states.length == 0) {
				// 已经没有下一个状态了，自动暂停状态机
				this.pause();
				_pauseData = data;
			} else {
				// 还有下一个状态。如果需要跳过，则直接跳过该状态进入下一个状态，否则进入该状态
				var entered:Boolean = false;
				for(var i:int = 0, len:int = _states.length; i < len; i++) {
					var stateEnter:IState = _states[0];
					if(!_context.skip || !stateEnter.skippable) {
						entered = true;
						stateEnter.onEnter(_context, data);
						break;
					}
					_states.shift();
				}
				// 如果跳过了所有状态，则自动暂停状态机
				if(!entered) {
					this.pause();
					_pauseData = data;
				}
			}
			return stateExit;
		}
		
		/**
		 * 手动pass掉当前状态，直接进入下一状态
		 * @param forceFinish 是否在pass掉状态时直接完成该状态
		 * @return 被pass掉的状态
		 */		
		public function pass(forceFinish:Boolean):IState
		{
			if(_states.length == 0) return null;
			var state:IState = _states[0];
			var manualDelete:Boolean = state.onPass(_context, forceFinish);
			if(!manualDelete) this.shift(state);
			return state;
		}
		
		/** 启动状态机 */
		public function start():void
		{
			if(!_running) {
				// 拷贝所有参数
				for(var key:* in _tempUserData) {
					_context.userData[key] = _tempUserData[key];
					delete _tempUserData[key];
				}
				_running = true;
				if(_states.length > 0)
				{
					// 进入第一个状态
					_states[0].onEnter(_context, null);
					// resume
					this.resume();
				}
				else
				{
					this.pause();
				}
			}
		}
		
		/** 停止状态机 */
		public function stop():void
		{
			if(_running) {
				// 调用第一个状态的onExit方法
				if(_states.length > 0) _states[0].onExit(_context);
				_running = false;
				// 销毁上下文
				_context.clear();
				// 恢复暂停状态
				_pause = false;
				_pauseData = null;
			}
		}
		
		/** 暂停在当前状态 */
		public function pause():void
		{
			_pause = true;
		}
		
		/** 重新开启 */
		public function resume():void
		{
			if(_pause && _states.length > 0) {
				_pause = false;
				// 还有下一个状态，进入下一个状态
				var stateEnter:IState = _states[0];
				var data:* = _pauseData;
				_pauseData = null;
				stateEnter.onEnter(_context, data);
			}
		}
		
		/** 跳过所有状态 */
		public function skipAllStates():void
		{
			_context.skip = true;
		}
		
		/** 清理所有状态 */
		public function clear():void
		{
			this.stop();
			// 移除掉所有状态
			for(var i:int = 0, len:int = _states.length; i < len; i++) {
				// 调用onRemove方法，并且将该状态移除掉
				_states[0].onRemove(_context);
				_states.shift();
			}
		}
		
		private static var _stateMachines:Vector.<StateMachine> = new Vector.<StateMachine>();
		private static var _updating:Boolean = false;
		private static var _lastTime:int;
		/**
		 * 托管状态机，如果状态内有需要update的状态，就需要托管。如果没有则可以不托管
		 * @param stateMachine 要托管的状态机
		 */		
		public static function delegateStateMachine(stateMachine:StateMachine):void
		{
			if(_stateMachines.indexOf(stateMachine) < 0) _stateMachines.push(stateMachine);
			if(!_updating) {
				RootManager.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_lastTime = getTimer();
				_updating = true;
			}
		}
		
		/**
		 * 取消托管状态机
		 * @param stateMachine 要取消托管的状态机
		 */		
		public static function undelegateStateMachine(stateMachine:StateMachine):void
		{
			var index:int = _stateMachines.indexOf(stateMachine);
			if(index >= 0) _stateMachines.splice(index, 1);
			if(_updating) {
				RootManager.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_lastTime = 0;
				_updating = false;
			}
		}
		
		private static function onEnterFrame(event:Event):void {
			// 计算毫秒间隔
			var time:int = getTimer();
			var delta:int = time - _lastTime;
			_lastTime = time;
			// 调用每一个已启动的状态机的onUpdate方法，将毫秒间隔传递过去
			for(var i:int = 0, len:int = _stateMachines.length; i < len; i++) {
				var stateMachine:StateMachine = _stateMachines[i];
				if(stateMachine.running) stateMachine.onUpdate(delta);
			}
		}
	}
}