package statemachine.engine.impl
{
import flash.events.Event;

import org.flexunit.asserts.fail;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.engine.api.CancellationReason;
import statemachine.engine.impl.events.StateChangedEvent;
import statemachine.engine.impl.events.TransitionEvent;
import statemachine.engine.support.MockTransitionInspector;
import statemachine.support.Reason;
import statemachine.support.StateName;

public class StateMachineTest
{
    private var _dispatcher:StateDispatcher;
    private var _classUnderTest:StateMachineEngine;
    private var _props:StateMachineProperties;
    private var _targetState:State;
    private var _currentState:State;
    private var _inspector:MockTransitionInspector;
    private var _dipatchedEvents:Array;

    [Before]
    public function before():void
    {
        _dispatcher = new StateDispatcher();
        _targetState = new State( StateName.TARGET );
        _currentState = new State( StateName.CURRENT );
        _props = new StateMachineProperties();
        _props.current = _currentState;
        _inspector = new MockTransitionInspector( true );
        _classUnderTest = new StateMachineEngine( _dispatcher, _inspector );
        _dipatchedEvents = [];
    }


    [Test]
    public function when_successful__changeState_sets_target_as_current_state():void
    {
        addTargetToCurrentState();
        setInspectorTo( true );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( _props.current, strictlyEqualTo( _targetState ) );
    }


    [Test]
    public function when_successful__changeState_returns_true():void
    {
        addTargetToCurrentState();
        setInspectorTo( true );
        assertThat( _classUnderTest.changeState( _targetState, _props ), isTrue() );
    }

    [Test]
    public function when_target_undeclared_in_current_state__there_is_no_change_of_state():void
    {
        setInspectorTo( false );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( _props.current, strictlyEqualTo( _currentState ) );
    }

    [Test]
    public function when_unsuccessful__changeState_returns_false():void
    {
        setInspectorTo( false );
        assertThat( _classUnderTest.changeState( _targetState, _props ), isFalse() );
    }

    [Test]
    public function when_successful__TEAR_DOWN_and_SET_UP_phases_are_dispatched_for_the_correct_states():void
    {
        setInspectorTo( true );
        _dispatcher.addEventListener( TransitionEvent.PHASE_CHANGED, onTransition );
        _classUnderTest.changeState( _targetState, _props );

        assertThat( _dipatchedEvents.length, equalTo( 2 ) );

        assertThat( _dipatchedEvents[0].phase, strictlyEqualTo( TransitionPhase.TEAR_DOWN ) );
        assertThat( _dipatchedEvents[1].phase, strictlyEqualTo( TransitionPhase.SET_UP ) );

        assertThat( _dipatchedEvents[0].stateName, strictlyEqualTo( StateName.CURRENT ));
        assertThat( _dipatchedEvents[1].stateName, strictlyEqualTo( StateName.TARGET ) );

    }


    [Test]
    public function when_unsuccessful__CANCELLATION_phase_is_dispatched():void
    {
        setInspectorTo( false, Reason.BECAUSE );
        _dispatcher.addEventListener( TransitionEvent.PHASE_CHANGED, onTransition );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( _dipatchedEvents.length, equalTo( 1 ) );
        assertThat( _dipatchedEvents[0].phase, strictlyEqualTo( TransitionPhase.CANCELLATION ) );
        assertThat( _dipatchedEvents[0].reason, strictlyEqualTo( Reason.BECAUSE ) );
    }

    [Test]
    public function when_successful_StateChangedEvent_STATE_CHANGED_event_is_dispatched():void
    {
        setInspectorTo( true );
        _dispatcher.addEventListener( StateChangedEvent.STATE_CHANGED, onTransition );
        _classUnderTest.changeState( _targetState, _props );

        assertThat( _dipatchedEvents.length, equalTo( 1 ) );
        assertThat( _dipatchedEvents[0], instanceOf( StateChangedEvent ) );
        assertThat( _dipatchedEvents[0].type, equalTo( StateChangedEvent.STATE_CHANGED ) );

    }

    [Test]
    public function when_unsuccessful_StateChangedEvent_FAILED_is_dispatched():void
    {
        setInspectorTo( false );
        _dispatcher.addEventListener( StateChangedEvent.FAILED, onTransition );
        _classUnderTest.changeState( _targetState, _props );

        assertThat( _dipatchedEvents.length, equalTo( 1 ) );
        assertThat( _dipatchedEvents[0], instanceOf( StateChangedEvent ) );
        assertThat( _dipatchedEvents[0].type, equalTo( StateChangedEvent.FAILED ) );

    }

    [Test]
    public function when_in_tear_down_phase__phase_property_set_as_TEAR_DOWN():void
    {
        var recievedPhase:TransitionPhase;
        const onTearDown:Function = function ( event:TransitionEvent ):void
        {
            if ( event.phase === TransitionPhase.TEAR_DOWN){
                recievedPhase = _props.phase
            }
        }

        setInspectorTo( true );

        _dispatcher.addEventListener( TransitionEvent.PHASE_CHANGED, onTearDown );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( recievedPhase, strictlyEqualTo( TransitionPhase.TEAR_DOWN ) );

    }

    [Test]
    public function when_in_set_up_phase__phase_property_set_as_SET_UPN():void
    {
        var recievedPhase:TransitionPhase;
        const onSetUp:Function = function ( event:TransitionEvent ):void
        {
            if ( event.phase === TransitionPhase.SET_UP){
                recievedPhase = _props.phase;
            }
        }

        setInspectorTo( true );

        _dispatcher.addEventListener( TransitionEvent.PHASE_CHANGED, onSetUp );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( recievedPhase, strictlyEqualTo( TransitionPhase.SET_UP ) );

    }

    [Test]
    public function after_successful_transition_phase_set_as_NULL():void
    {
        setInspectorTo( true );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( _props.phase, strictlyEqualTo( TransitionPhase.NULL ) );

    }


    [Test]
    public function when_in_cancellation_phase__properties_are_set_as_expected():void
    {
        var recievedPhase:TransitionPhase;
        var recievedReason:CancellationReason;
        const onCancel:Function = function ( event:TransitionEvent ):void
        {
            if ( event.phase === TransitionPhase.CANCELLATION){
                recievedPhase = _props.phase;
                recievedReason = _props.reason;
            }
        }

        setInspectorTo( false, Reason.BECAUSE );

        _dispatcher.addEventListener( TransitionEvent.PHASE_CHANGED, onCancel );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( recievedPhase, strictlyEqualTo( TransitionPhase.CANCELLATION ) );
        assertThat( recievedReason, strictlyEqualTo( Reason.BECAUSE ) );

    }

    [Test]
    public function after_unsuccessful_properties_set_as_NULL():void
    {
        setInspectorTo( false, Reason.BECAUSE );
        _classUnderTest.changeState( _targetState, _props );
        assertThat( _props.phase, strictlyEqualTo( TransitionPhase.NULL ) );
        assertThat( _props.reason, strictlyEqualTo( CancellationReason.NULL ) );

    }

    [Test(expects='statemachine.engine.impl.errors.NestedTransitionError')]
    public function nested_state_change_within_tear_down_phase_throws_error():void
    {
        setInspectorTo( true );
        _props.phase = TransitionPhase.TEAR_DOWN;
        _classUnderTest.changeState( _targetState, _props );

    }

    [Test(expects='statemachine.engine.impl.errors.NestedTransitionError')]
    public function nested_state_change_within_set_up_phase_throws_error():void
    {
        setInspectorTo( true );
        _props.phase = TransitionPhase.SET_UP;
        _classUnderTest.changeState( _targetState, _props );

    }
    [Test(expects='statemachine.engine.impl.errors.NestedTransitionError')]
    public function nested_state_change_within_cancellation_phase_throws_error():void
    {
        setInspectorTo( false );
        _props.phase = TransitionPhase.CANCELLATION;
        _classUnderTest.changeState( _targetState, _props );

    }



    private function setInspectorTo( result:Boolean, reason:CancellationReason = null ):void
    {
        _inspector.result = result;
        _inspector.reason = reason;
    }

    private function addTargetToCurrentState():void
    {
        _props.current.addTarget( _targetState.name );
    }

    private function onTransition( event:Event ):void
    {
        _dipatchedEvents.push( event );
    }
}
}
