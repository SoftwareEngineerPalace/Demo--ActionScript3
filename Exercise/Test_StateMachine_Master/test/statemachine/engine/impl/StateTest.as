package statemachine.engine.impl
{
import flash.events.Event;

import mockolate.prepare;
import mockolate.strict;
import mockolate.stub;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.support.guards.GrumpyStateGuard;

import statemachine.support.guards.HappyStateGuard;

import statemachine.support.StateName;

public class StateTest
{

    private var _classUnderTest:State;
    private var _targetState:State;

    [Before(order=1, async, timeout=5000)]
    public function prepareMockolates():void
    {
        Async.proceedOnEvent(
                this,
                prepare( State ),
                Event.COMPLETE );
    }

    [Before(order=2)]
    public function before():void
    {
        stubTargetState();
        _classUnderTest = new State( StateName.CLIENT );
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
        _targetState = null;
    }

    [Test]
    public function name_is_set_from_constructor():void
    {
        assertThat( _classUnderTest.name, equalTo( StateName.CLIENT ) );
    }

    [Test]
    public function addTransitionTarget_returns_true_if_successful():void
    {
        assertThat( _classUnderTest.addTarget( StateName.TARGET ), isTrue() );
    }

    [Test]
    public function addTransitionTarget_returns_false_if_already_registered():void
    {
        _classUnderTest.addTarget( StateName.TARGET );
        assertThat( _classUnderTest.addTarget( StateName.TARGET ), isFalse() );
    }

    [Test]
    public function hasTransitionTarget_returns_false_for_unregistered_State():void
    {
        assertThat( _classUnderTest.hasTarget( StateName.TARGET ), isFalse() );
    }

    [Test]
    public function hasTransitionTarget_returns_true_for_registered_State():void
    {
        _classUnderTest.addTarget( StateName.TARGET )
        assertThat( _classUnderTest.hasTarget( StateName.TARGET ), isTrue() );
    }

    [Test]
    public function addEntryGuard_pushed_to_entryGuards():void
    {
        _classUnderTest.addEntryGuard( HappyStateGuard );
        _classUnderTest.addEntryGuard( HappyStateGuard );
        _classUnderTest.addEntryGuard( GrumpyStateGuard );
        assertThat(
                _classUnderTest.entryGuards,
                array(
                        strictlyEqualTo( HappyStateGuard ),
                        strictlyEqualTo( HappyStateGuard ),
                        strictlyEqualTo( GrumpyStateGuard )
                ) );
    }

    [Test]
    public function addExitGuard_pushed_to_exitGuards():void
    {
        _classUnderTest.addExitGuard( HappyStateGuard );
        _classUnderTest.addExitGuard( GrumpyStateGuard );
        _classUnderTest.addExitGuard( GrumpyStateGuard );
        assertThat(
                _classUnderTest.exitGuards,
                array(
                        strictlyEqualTo( HappyStateGuard ),
                        strictlyEqualTo( GrumpyStateGuard ),
                        strictlyEqualTo( GrumpyStateGuard )
                ) );
    }

    private function stubTargetState():void
    {
        _targetState = strict( State );
        stub( _targetState ).getter( "name" ).returns( StateName.TARGET );
    }

}
}
