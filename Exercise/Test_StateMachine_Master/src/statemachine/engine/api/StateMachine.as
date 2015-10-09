package statemachine.engine.api
{
import flash.events.IEventDispatcher;

public interface StateMachine
{
    function get dispatcher():IEventDispatcher
    function get properties ():FSMProperties
    function changeState( targetState:String ):Boolean;

}
}
