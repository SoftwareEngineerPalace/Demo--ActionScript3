package statemachine.engine.builders
{
import statemachine.engine.api.*;
import statemachine.engine.impl.State;

public class StateBuilder
{
    internal var state:State;
    private var _parent:FSMBuilder;


    public function StateBuilder( clientState:State, parent:FSMBuilder ):void
    {
        state = clientState;
        _parent = parent;
    }

    public function withEntryGuards( ...guards ):StateBuilder
    {
        for each ( var guard:* in guards )
            state.addEntryGuard( guard );

        return this;
    }

    public function withExitGuards( ...guards ):StateBuilder
    {
        for each ( var guard:* in guards )
            state.addExitGuard( guard );

        return this;
    }

    public function withTargets( ...states ):StateBuilder
    {
        for each ( var name:String in states )
        {
            state.addTarget( name );
        }

        return this;
    }

    public function get and():FSMBuilder
    {
        return _parent;
    }


}
}
