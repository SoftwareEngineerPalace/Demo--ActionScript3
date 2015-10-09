package statemachine.engine.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;

import statemachine.engine.impl.events.TransitionEvent;

import statemachine.support.Reason;
import statemachine.support.StateName;

public class TransitionEventTest
{
    private var _event:TransitionEvent;

    [Before]
    public function before():void
    {
        _event =
                new TransitionEvent(
                        new State( StateName.ONE ),
                        TransitionPhase.SET_UP,
                        Reason.BECAUSE
                );
    }

    [Test]
    public function type_is_PHASED_CHANGED():void
    {
        assertThat( _event.type, equalTo( TransitionEvent.PHASE_CHANGED ) );
    }

    [Test]
    public function state_passed_in_constructor():void
    {
        assertThat( _event.stateName, equalTo( StateName.ONE ) );
    }

    [Test]
    public function phaseName_passed_in_constructor():void
    {
        assertThat( _event.phase, equalTo( TransitionPhase.SET_UP ) );
    }


    [Test]
    public function reason_passed_in_constructor():void
    {
        assertThat( _event.reason, equalTo( Reason.BECAUSE ) );
    }

    [Test]
    public function clone_returns_instance_of_TransitionEvent():void
    {
        assertThat( _event.clone(), instanceOf( TransitionEvent ) );
    }

    [Test]
    public function clone_stateName_is_identical():void
    {
        const clone:TransitionEvent = _event.clone() as TransitionEvent;
        assertThat( clone.stateName, equalTo( _event.stateName ) );
    }

    [Test]
    public function clone_phaseName_is_identical():void
    {
        const clone:TransitionEvent = _event.clone() as TransitionEvent;
        assertThat( clone.phase, equalTo( _event.phase ) );
    }


    [Test]
    public function clone_reason_is_identical():void
    {
        const clone:TransitionEvent = _event.clone() as TransitionEvent;
        assertThat( clone.reason, equalTo( _event.reason ) );
    }
}
}


