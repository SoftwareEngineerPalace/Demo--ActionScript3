package statemachine.engine.api
{
public interface FSMProperties
{
    function get currentState():String;
    function get currentTarget():String;

    function get currentPhase():String;
}
}
