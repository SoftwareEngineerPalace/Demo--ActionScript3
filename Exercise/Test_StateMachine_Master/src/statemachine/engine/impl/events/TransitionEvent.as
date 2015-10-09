package statemachine.engine.impl.events
{
import statemachine.engine.impl.*;

import flash.events.Event;

import statemachine.engine.api.CancellationReason;

public class TransitionEvent extends Event
{

    public static const PHASE_CHANGED:String = "TransitionEvent/phaseChanged";
    private var _state:State;
    private var _phase:TransitionPhase;
    private var _reason:CancellationReason;

    public function TransitionEvent( state:State,
                                     phase:TransitionPhase,
                                     reason:CancellationReason = null )
    {
        _state = state;
        _phase = phase;
        _reason = reason || CancellationReason.NULL;
        super( PHASE_CHANGED, false, false );
    }


    public function get stateName():String
    {
        return _state.name;
    }

    public function get phase():TransitionPhase
    {
        return _phase;
    }

    public function get reason():CancellationReason
    {
        return _reason;
    }


    public override function clone():Event
    {
        return new TransitionEvent( _state, phase, reason );
    }
}
}
