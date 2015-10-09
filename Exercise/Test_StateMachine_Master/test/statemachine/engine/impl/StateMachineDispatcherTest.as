package statemachine.engine.impl
{
import flash.events.Event;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.engine.api.CancellationReason;
import statemachine.engine.impl.events.StateChangedEvent;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.support.Reason;
import statemachine.support.StateName;

public class StateMachineDispatcherTest
{
    private var _classUnderTest:StateDispatcher;
    private var _state:State;
    private var _recievedEvent:Event;

    [Before]
    public function before():void
    {
        _classUnderTest = new StateDispatcher();
        _classUnderTest.addEventListener( TransitionEvent.PHASE_CHANGED, onPhaseChanged );
        _classUnderTest.addEventListener( StateChangedEvent.STATE_CHANGED, onStateChanged );
        _classUnderTest.addEventListener( StateChangedEvent.FAILED, onStateChanged );
        _state = new State( StateName.ONE );
    }

    [Test]
    public function forState_returns_self():void
    {
        assertThat( _classUnderTest.forState( _state ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function inPhase_returns_self():void
    {
        assertThat( _classUnderTest.inPhase( TransitionPhase.NULL ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function because_returns_self():void
    {
        assertThat( _classUnderTest.because( CancellationReason.NULL ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function dispatch_dispatches_TransitionEvent():void
    {
        _classUnderTest.dispatchPhaseChange();
        assertThat( _recievedEvent, instanceOf( TransitionEvent ) );
    }

    [Test]
    public function by_default_TransitionEvent_properties_are_NULL():void
    {
        _classUnderTest.dispatchPhaseChange();
        const event:TransitionEvent = _recievedEvent as TransitionEvent;
        assertThat( event.stateName, strictlyEqualTo( State.NULL.name ) );
        assertThat( event.phase, strictlyEqualTo( TransitionPhase.NULL ) );
        assertThat( event.reason, strictlyEqualTo( CancellationReason.NULL ) );

    }

    [Test]
    public function forState_sets_state_on_TransitionEvent():void
    {
        _classUnderTest
                .forState( _state )
                .dispatchPhaseChange();

        const event:TransitionEvent = _recievedEvent as TransitionEvent;
        assertThat( event.stateName, strictlyEqualTo( _state.name ) );
    }

    [Test]
    public function forPhase_sets_phase_on_TransitionEvent():void
    {
        _classUnderTest
                .inPhase( TransitionPhase.SET_UP )
                .dispatchPhaseChange();

        const event:TransitionEvent = _recievedEvent as TransitionEvent;
        assertThat( event.phase, strictlyEqualTo( TransitionPhase.SET_UP ) );
    }

    [Test]
    public function because_sets_reason_on_TransitionEvent():void
    {
        _classUnderTest
                .because( Reason.BECAUSE )
                .dispatchPhaseChange();

        const event:TransitionEvent = _recievedEvent as TransitionEvent;
        assertThat( event.reason, strictlyEqualTo( Reason.BECAUSE ) );
    }

    [Test]
    public function all_properties_are_set_on_TransitionEvent_when_chained():void
    {
        _classUnderTest
                .forState( _state )
                .inPhase( TransitionPhase.SET_UP )
                .because( Reason.BECAUSE )
                .dispatchPhaseChange();

        const event:TransitionEvent = _recievedEvent as TransitionEvent;
        assertThat( event.stateName, strictlyEqualTo( _state.name ) );
        assertThat( event.phase, strictlyEqualTo( TransitionPhase.SET_UP ) );
        assertThat( event.reason, strictlyEqualTo( Reason.BECAUSE ) );
    }

    [Test]
    public function all_properties_are_reset_after_dispatchPhase():void
    {
        _classUnderTest
                .forState( _state )
                .inPhase( TransitionPhase.SET_UP )
                .because( Reason.BECAUSE )
                .dispatchPhaseChange();

        _classUnderTest.dispatchPhaseChange();

        const event:TransitionEvent = _recievedEvent as TransitionEvent;
        assertThat( event.stateName, strictlyEqualTo( State.NULL.name ) );
        assertThat( event.phase, strictlyEqualTo( TransitionPhase.NULL ) );
        assertThat( event.reason, strictlyEqualTo( CancellationReason.NULL ) );
    }

    [Test]
    public function dispatchChange_dispatches_StateChangedEvent_STATE_CHANGED_with_StateMachineProperties():void
    {
        const props:StateMachineProperties = new StateMachineProperties();
        _classUnderTest.dispatchChange( props );

        const event:StateChangedEvent = _recievedEvent as StateChangedEvent;
        assertThat( event, instanceOf( StateChangedEvent ) );
        assertThat( event.type, equalTo( StateChangedEvent.STATE_CHANGED ) );
        assertThat( event.properties, strictlyEqualTo( props ) )
    }

    [Test]
    public function dispatchFailed_dispatches_StateChangedEvent_FAILED_with_StateMachineProperties():void
    {
        const props:StateMachineProperties = new StateMachineProperties();
        _classUnderTest.dispatchFailed( props );

        const event:StateChangedEvent = _recievedEvent as StateChangedEvent;
        assertThat( event, instanceOf( StateChangedEvent ) );
        assertThat( event.type, equalTo( StateChangedEvent.FAILED ) );
        assertThat( event.properties, strictlyEqualTo( props ) )
    }

    private function onPhaseChanged( event:TransitionEvent ):void
    {
        _recievedEvent = event;
    }

    private function onStateChanged( event:StateChangedEvent ):void
    {
        _recievedEvent = event;
    }


}
}


