package statemachine.engine.impl.events
{
import flash.events.Event;

import statemachine.engine.api.FSMProperties;

public class StateChangedEvent extends Event
{

    public static const STATE_CHANGED:String = "StateChangedEvent/stateChanged";
    public static const FAILED:String = "StateChangedEvent/failed";

    private var _props:FSMProperties;

    public function StateChangedEvent( type:String, props:FSMProperties )
    {
        _props = props;

        super( type, false, false );
    }


    public function get properties():FSMProperties
    {
        return _props;
    }


    public override function clone():Event
    {
        return new StateChangedEvent( type, _props );
    }
}
}
