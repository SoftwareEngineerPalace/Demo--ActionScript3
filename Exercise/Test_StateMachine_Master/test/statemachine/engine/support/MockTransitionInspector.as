package statemachine.engine.support
{
import statemachine.engine.api.CancellationReason;
import statemachine.engine.impl.Approval;
import statemachine.engine.impl.StateMachineProperties;
import statemachine.engine.impl.TransitionInspector;

public class MockTransitionInspector extends TransitionInspector
{
    public var result:Boolean;
    public var reason:CancellationReason;

    public function MockTransitionInspector( result:Boolean, reason:CancellationReason = null )
    {
        super( null );
        this.result = result;
        this.reason = reason || CancellationReason.NULL;
    }

    override public function inspect( props:StateMachineProperties ):Approval
    {
        return new Approval( result, reason );
    }
}
}
