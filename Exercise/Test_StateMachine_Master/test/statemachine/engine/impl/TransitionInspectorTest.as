package statemachine.engine.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.RobotlegsInjector;

import statemachine.engine.impl.reasons.UndeclaredTarget;
import statemachine.support.Reason;
import statemachine.support.StateName;
import statemachine.support.guards.GrumpyStateGuard;
import statemachine.support.guards.GrumpyStateGuardWithReason;
import statemachine.support.guards.HappyStateGuard;

public class TransitionInspectorTest
{
    private var _injector:IInjector;
    private var _classUnderTest:TransitionInspector;
    private var _current:State;
    private var _target:State;
    private var _props:StateMachineProperties;

    [Before]
    public function before():void
    {
        _injector = new RobotlegsInjector();
        _current = new State( StateName.CURRENT );
        _target = new State( StateName.TARGET );
        _props = new StateMachineProperties();
        _props.current = _current;
        _props.target = _target;
        _classUnderTest = new TransitionInspector( _injector );
    }

    [Test]
    public function when_target_declared_in_current__returns_true():void
    {
        addTargetToCurrentState();
        assertThat( _classUnderTest.inspect( _props ).approved, isTrue() );
    }

    [Test]
    public function when_target_undeclared_in_current__returns_false():void
    {
        assertThat( _classUnderTest.inspect( _props ).approved, isFalse() );
    }

    [Test]
    public function when_current_is_NULL__returns_true():void
    {
        _props.current = State.NULL;
        assertThat( _classUnderTest.inspect( _props ).approved, isTrue() );
    }

    [Test]
    public function when_target_undeclared_in_current__injects_reason():void
    {
        assertThat( _classUnderTest.inspect( _props ).reason, instanceOf( UndeclaredTarget ) );
    }

    [Test]
    public function when_target_undeclared_in_current__reason_has_correct_desc():void
    {
        assertThat(
                _classUnderTest.inspect( _props ).reason.desc,
                equalTo( "state " + _target.name + "is undeclared in " + _current.name )
        );
    }

    [Test]
    public function when_current_has_grumpy_exit_guard__returns_false():void
    {
        addTargetToCurrentState();
        addExitGuardToCurrentState( GrumpyStateGuard );
        assertThat( _classUnderTest.inspect( _props ).approved, isFalse() );
    }

    [Test]
    public function when_current_has_happy_exit_guard__returns_true():void
    {
        addTargetToCurrentState();
        addExitGuardToCurrentState( HappyStateGuard );
        assertThat( _classUnderTest.inspect( _props ).approved, isTrue() );
    }

    [Test]
    public function when_target_has_grumpy_entry_guard__returns_false():void
    {
        addTargetToCurrentState();
        addEntryGuardToTargetState( GrumpyStateGuard );
        assertThat( _classUnderTest.inspect( _props ).approved, isFalse() );
    }

    [Test]
    public function when_target_has_happy_entry_guard__returns_true():void
    {
        addTargetToCurrentState();
        addEntryGuardToTargetState( HappyStateGuard );
        assertThat( _classUnderTest.inspect( _props ).approved, isTrue() );
    }

    [Test]
    public function when_grumpy_guard_forbids_transition__returns_reason_if_available():void
    {
        addTargetToCurrentState();
        addExitGuardToCurrentState( GrumpyStateGuardWithReason );
        assertThat( _classUnderTest.inspect( _props ).reason, strictlyEqualTo( Reason.BECAUSE ) );
    }

    private function addTargetToCurrentState():void
    {
        _current.addTarget( _target.name );
    }

    private function addExitGuardToCurrentState( guardClass:Class ):void
    {
        _current.addExitGuard( guardClass );
    }

    private function addEntryGuardToTargetState( guardClass:Class ):void
    {
        _target.addEntryGuard( guardClass )
    }
}
}
