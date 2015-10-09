package statemachine.engine
{
import org.hamcrest.assertThat;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.RobotlegsInjector;

import statemachine.engine.api.*;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.StateMachineEngine;
import statemachine.engine.impl.StateMachineProperties;
import statemachine.engine.impl.StateProvider;
import statemachine.engine.impl.TransitionInspector;

public class FSMConfigurationTest
{
    private var _injector:IInjector;
    private var _classUnderTest:FSMConfiguration;

    [Before]
    public function before():void
    {
        _injector = new RobotlegsInjector();
        _classUnderTest = new FSMConfiguration( _injector );
    }

    [Test]
    public function constructor_creates_child_injector():void
    {
        assertThat( _classUnderTest.injector.parent, strictlyEqualTo( _injector ) )
    }

    [Test]
    public function configure_maps_StateProvider_to_childInjector():void
    {
        _classUnderTest.configure();
        assertThat( _classUnderTest.injector.hasMapping( StateProvider ), isTrue() );
    }

    [Test]
    public function configure_maps_itself_to_Injector():void
    {
        _classUnderTest.configure();
        assertThat( _classUnderTest.injector.getInstance( IInjector ), strictlyEqualTo( _classUnderTest.injector ) );

    }

    [Test]
    public function configure_maps_TransitionInspector_to_childInjector():void
    {
        _classUnderTest.configure();
        assertThat( _classUnderTest.injector.hasMapping( TransitionInspector ), isTrue() );

    }

    [Test]
    public function configure_maps_StateMachineProperties_to_childInjector():void
    {
        _classUnderTest.configure();
        assertThat( _classUnderTest.injector.hasMapping( StateMachineProperties ), isTrue() );

    }

    [Test]
    public function configure_maps_StateMachineEngine_to_childInjector():void
    {
        _classUnderTest.configure();
        assertThat( _classUnderTest.injector.hasMapping( StateMachineEngine ), isTrue() );

    }

    [Test]
    public function configure_maps_FSMBuilder_to_injector():void
    {
        _classUnderTest.configure();
        assertThat( _injector.hasMapping( FSMBuilder ), isTrue() );

    }

    [Test]
    public function configure_maps_FSM_to_injector():void
    {
        _classUnderTest.configure();
        assertThat( _injector.hasMapping( StateMachine ), isTrue() );

    }

    [Test]
    public function configure_maps_StateDispatcher_to_childInjector():void
    {
        _classUnderTest.configure();
        assertThat( _classUnderTest.injector.hasMapping( StateDispatcher ), isTrue() );

    }


}


}
