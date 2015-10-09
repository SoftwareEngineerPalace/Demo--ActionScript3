package statemachine.engine.impl
{
import flash.events.IEventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.engine.api.FSMProperties;
import statemachine.engine.support.MockStateMachineEngine;
import statemachine.engine.support.MockStateProvider;
import statemachine.support.StateName;

public class StateMachineDriverTest
{
    private var _provider:MockStateProvider;
    private var _engine:MockStateMachineEngine;
    private var _classUnderTest:StateMachineDriver;
    private var _props:StateMachineProperties;
    private var _dispatcher:StateDispatcher;


    [Before]
    public function before():void
    {
        _engine = new MockStateMachineEngine();
        _provider = new MockStateProvider();
        _props = new StateMachineProperties();
        _dispatcher = new StateDispatcher();
        _classUnderTest = new StateMachineDriver( _engine, _provider, _props, _dispatcher );
    }

    [Test]
    public function properties_returns_instanceOf_FSMProperties():void
    {
        assertThat( _classUnderTest.properties, instanceOf( FSMProperties ) );
    }

    [Test]
    public function properties_returns_StateMachineProperties_passed_in_constructor():void
    {
        assertThat( _classUnderTest.properties, strictlyEqualTo( _props ) );
    }

    [Test]
    public function properties_returns_instanceOf_IEventDispatcher():void
    {
        assertThat( _classUnderTest.dispatcher, instanceOf( IEventDispatcher ) );
    }


    [Test]
    public function properties_returns_StateDispatcher_passed_in_constructor():void
    {
        assertThat( _classUnderTest.dispatcher, strictlyEqualTo( _dispatcher ) );
    }

    [Test]
    public function when_changeState_called_driver_checks_state_exists():void
    {
        _classUnderTest.changeState( StateName.ONE );
        assertThat( _provider.targetChecked, equalTo( StateName.ONE ) );
    }

    [Test]
    public function when_state_exists__driver_gets_state():void
    {
        setHasState( true );
        _classUnderTest.changeState( StateName.ONE );
        assertThat( _provider.targetsGot, equalTo( StateName.ONE ) );
    }

    [Test]
    public function when_state_does_not_exists__driver_does_not_get_state():void
    {
        setHasState( false );
        _classUnderTest.changeState( StateName.ONE );
        assertThat( _provider.targetsGot, nullValue() );
    }

    [Test]
    public function when_state_does_not_exists__returns_false():void
    {
        setHasState( false );
        assertThat( _classUnderTest.changeState( StateName.ONE ), isFalse() );
    }

    [Test]
    public function when_state_does_exists__returns_true():void
    {
        setHasState( true );
        assertThat( _classUnderTest.changeState( StateName.ONE ), isTrue() );
    }

    [Test]
    public function when_state_exists__driver_calls_engine_changeState_with_target_State():void
    {
        const state:State = new State( StateName.TARGET );
        setHasState( true );
        setTargetState( state );
        _classUnderTest.changeState( StateName.ONE );
        assertThat( _engine.targetStateReceived, strictlyEqualTo( state ) );
    }

    private function setHasState( hasState:Boolean ):void
    {
        _provider.hasStateValue = hasState;
    }

    private function setTargetState( state:State ):void
    {
        _provider.stateValue = state;
    }
}
}
