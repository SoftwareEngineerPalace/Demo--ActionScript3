package statemachine.engine
{
import flash.events.Event;
import flash.events.ProgressEvent;

import org.hamcrest.assertThat;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.strictlyEqualTo;

import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.RobotlegsInjector;

import statemachine.flow.api.*;
import statemachine.support.TestEvent;

public class PayLoadTest
{
    private var _classUnderTest:Payload;
    private var _injector:IInjector;

    [Before]
    public function before():void
    {
        _injector = new RobotlegsInjector();
        _classUnderTest = new Payload();
    }

    [Test]
    public function add_returns_self():void
    {
        assertThat( _classUnderTest.add( null, null ), strictlyEqualTo( _classUnderTest ) );
    }

    [Test]
    public function inject_injects_payload_into_injector():void
    {
        const event:Event = new Event( Event.COMPLETE );
        const progEvent:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS );
        _classUnderTest
                .add( event, Event )
                .add( progEvent, ProgressEvent );

        _classUnderTest.inject( _injector );

        assertThat( _injector.getInstance( Event ), strictlyEqualTo( event ) );
        assertThat( _injector.getInstance( ProgressEvent ), strictlyEqualTo( progEvent ) );
    }

    [Test]
    public function inject_removes_payload_from_injector():void
    {
        const event:Event = new Event( Event.COMPLETE );
        const progEvent:ProgressEvent = new ProgressEvent( ProgressEvent.PROGRESS );
        _classUnderTest
                .add( event, Event )
                .add( progEvent, ProgressEvent );

        _classUnderTest.inject( _injector );
        _classUnderTest.remove( _injector );

        assertThat( _injector.hasMapping( Event ), isFalse() );
        assertThat( _injector.hasMapping( ProgressEvent ), isFalse() );
    }

    [Test]
    public function get_returns_value_from_classRef():void
    {
        const event:Event = new Event( Event.COMPLETE );
        const progEvent:TestEvent = new TestEvent( "Hello" );
        _classUnderTest
                .add( event, Event )
                .add( progEvent, TestEvent );


        assertThat( _classUnderTest.get( Event ), strictlyEqualTo( event ) );
    }


}
}
