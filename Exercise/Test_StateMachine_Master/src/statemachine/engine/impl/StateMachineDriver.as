package statemachine.engine.impl
{
import flash.events.IEventDispatcher;

import statemachine.engine.api.StateMachine;
import statemachine.engine.api.FSMProperties;

public class StateMachineDriver implements StateMachine
{
    private var _engine:StateMachineEngine;
    private var _provider:StateProvider;
    private var _props:StateMachineProperties;
    private var _dispatcher:StateDispatcher;

    public function StateMachineDriver( engine:StateMachineEngine,
                                        provider:StateProvider,
                                        props:StateMachineProperties,
                                        dispatcher:StateDispatcher ):void
    {
        _engine = engine;
        _provider = provider;
        _props = props;
        _dispatcher = dispatcher;

    }

    public function changeState( targetState:String ):Boolean
    {
        if ( _provider.hasState( targetState ) )
        {
            const target:State = _provider.getState( targetState );
            return _engine.changeState(target, _props);
        }
        return false;
    }

    public function get properties():FSMProperties
    {
        return _props;
    }

    public function get dispatcher():IEventDispatcher
    {
        return _dispatcher
    }
}
}
