package statemachine.engine.builders
{
import statemachine.engine.api.*;

import org.hamcrest.assertThat;
import org.hamcrest.collection.array;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.engine.builders.StateBuilder;

import statemachine.engine.impl.State;
import statemachine.support.guards.GrumpyStateGuard;
import statemachine.support.guards.HappyStateGuard;
import statemachine.engine.support.StubFSMBuilder;
import statemachine.support.StateName;

public class StateBuilderTest
{
    private var _classUnderTest:StateBuilder;
    private var _state:State;
    private var _parentBuilder:StubFSMBuilder;


    [Before]
    public function before():void
    {
        _state = new State( StateName.ONE );
        _parentBuilder = new StubFSMBuilder();
        _classUnderTest = new StateBuilder( _state, _parentBuilder);
    }

    [Test]
    public function and_returns_instanceOf_FSMBuilder():void
    {
        assertThat( _classUnderTest.and, instanceOf( FSMBuilder ) );
    }

    [Test]
    public function and_returns_parentBuilder():void
    {
        assertThat( _classUnderTest.and, strictlyEqualTo( _parentBuilder ) );
    }

    [Test]
    public function withEntryGuards_returns_self():void
    {
        assertThat( _classUnderTest.withEntryGuards( HappyStateGuard ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function withExitGuards_returns_self():void
    {
        assertThat( _classUnderTest.withExitGuards( HappyStateGuard ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function withTargets_returns_self():void
    {
        assertThat( _classUnderTest.withTargets( StateName.ONE ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function withEntryGuards_adds_entry_guards_to_client():void
    {
        _classUnderTest.withEntryGuards( HappyStateGuard, GrumpyStateGuard, HappyStateGuard );
        assertThat(
                _state.entryGuards,
                array(
                        HappyStateGuard,
                        GrumpyStateGuard,
                        HappyStateGuard
                ) );
    }

    [Test]
    public function withExitGuards_adds_exit_guards_to_client():void
    {
        _classUnderTest.withExitGuards( GrumpyStateGuard, HappyStateGuard, GrumpyStateGuard );
        assertThat(
                _state.exitGuards,
                array(
                        GrumpyStateGuard,
                        HappyStateGuard,
                        GrumpyStateGuard
                ) );
    }

    [Test]
    public function withTargets_adds_state_names_to_client():void
    {
        _classUnderTest.withTargets( StateName.CLIENT, StateName.FOUR, StateName.TARGET );
        assertThat( _state.hasTarget( StateName.CLIENT ), isTrue() );
        assertThat( _state.hasTarget( StateName.FOUR ), isTrue() );
        assertThat( _state.hasTarget( StateName.TARGET ), isTrue() );
    }


}
}
