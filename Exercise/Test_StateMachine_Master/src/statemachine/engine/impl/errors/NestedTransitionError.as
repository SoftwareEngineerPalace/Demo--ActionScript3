package statemachine.engine.impl.errors
{
import statemachine.engine.api.FSMProperties;

public class NestedTransitionError extends Error
{
    public function NestedTransitionError( props:FSMProperties )
    {
        super( "State change attempted from phase "
                + props.currentPhase
                + " of an currently executing transition from state "
                + props.currentState
                + " to state "
                + props.currentTarget );
    }

}
}
