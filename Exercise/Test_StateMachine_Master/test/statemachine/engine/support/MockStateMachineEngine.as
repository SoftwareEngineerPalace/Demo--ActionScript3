package statemachine.engine.support
{
import statemachine.engine.impl.State;
import statemachine.engine.impl.StateMachineEngine;
import statemachine.engine.impl.StateMachineProperties;

public class MockStateMachineEngine extends StateMachineEngine
{
    public var targetStateReceived:State;

    public function MockStateMachineEngine()
    {
        super( null, null );
    }

    override public function changeState( target:State, props:StateMachineProperties ):Boolean
    {
        targetStateReceived = target ;
        return true;
    }


}
}
