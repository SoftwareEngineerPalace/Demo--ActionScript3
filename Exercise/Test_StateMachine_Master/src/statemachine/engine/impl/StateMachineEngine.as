package statemachine.engine.impl
{
import statemachine.engine.api.CancellationReason;
import statemachine.engine.impl.errors.NestedTransitionError;

public class StateMachineEngine
{
    private var _dispatcher:StateDispatcher;
    private var _inspector:TransitionInspector;

    public function StateMachineEngine( dispatcher:StateDispatcher, approval:TransitionInspector )
    {
        _dispatcher = dispatcher;
        _inspector = approval;
    }

    public function changeState( target:State, props:StateMachineProperties ):Boolean
    {
        if ( props.phase != TransitionPhase.NULL )
            throw new NestedTransitionError( props );

        props.target = target;
        const approval:Approval = _inspector.inspect( props );

        if ( approval.approved )
        {
            props.phase = TransitionPhase.TEAR_DOWN;
            _dispatcher
                    .forState( props.current )
                    .inPhase( TransitionPhase.TEAR_DOWN )
                    .dispatchPhaseChange();

            props.current = target;

            props.phase = TransitionPhase.SET_UP;
            _dispatcher
                    .forState( props.target )
                    .inPhase( TransitionPhase.SET_UP )
                    .dispatchPhaseChange();

            props.phase = TransitionPhase.NULL;
            _dispatcher.dispatchChange( props );

            return true;
        }

        else
        {
            props.phase = TransitionPhase.CANCELLATION;
            props.reason = approval.reason;
            _dispatcher
                    .forState( props.current )
                    .inPhase( TransitionPhase.CANCELLATION )
                    .because( approval.reason )
                    .dispatchPhaseChange();

            props.phase = TransitionPhase.NULL;
            props.reason = CancellationReason.NULL;
            _dispatcher.dispatchFailed( props );

            return false;
        }
    }
}
}
