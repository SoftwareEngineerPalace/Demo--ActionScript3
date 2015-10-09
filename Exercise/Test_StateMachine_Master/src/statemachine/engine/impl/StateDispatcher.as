package statemachine.engine.impl
{
import flash.events.EventDispatcher;

import statemachine.engine.api.CancellationReason;
import statemachine.engine.impl.events.StateChangedEvent;
import statemachine.engine.impl.events.TransitionEvent;

public class StateDispatcher extends EventDispatcher
{
    private var _state:State = State.NULL;
    private var _phase:TransitionPhase = TransitionPhase.NULL;
    private var _reason:CancellationReason = CancellationReason.NULL;

    public function dispatchPhaseChange():void
    {
        dispatchEvent( new TransitionEvent( _state, _phase, _reason ) );
        _state = State.NULL;
        _phase = TransitionPhase.NULL;
        _reason = CancellationReason.NULL;
    }

    public function dispatchChange( props:StateMachineProperties ):void
    {
        dispatchEvent( new StateChangedEvent( StateChangedEvent.STATE_CHANGED, props ) );
    }

    public function dispatchFailed( props:StateMachineProperties ):void
    {
        dispatchEvent( new StateChangedEvent( StateChangedEvent.FAILED, props ) );
    }

    public function forState( state:State ):StateDispatcher
    {
        _state = state;
        return this;
    }

    public function inPhase( phase:TransitionPhase ):StateDispatcher
    {
        _phase = phase;
        return this;
    }

    public function because( reason:CancellationReason ):StateDispatcher
    {
        _reason = reason;
        return this;
    }
}
}
