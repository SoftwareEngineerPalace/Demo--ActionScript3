package statemachine.engine.impl
{
public class TransitionPhase
{
    public static const NULL:TransitionPhase = new TransitionPhase( "transition/NULL" );
    public static const SET_UP:TransitionPhase = new TransitionPhase( "transition/setUp" );
    public static const TEAR_DOWN:TransitionPhase = new TransitionPhase( "transition/tearDown" );
    public static const CANCELLATION:TransitionPhase = new TransitionPhase( "transition/cancellation" );

    public function TransitionPhase( name:String )
    {
        _name = name;
    }

    private var _name:String;

    public function get name():String
    {
        return _name;
    }

    public function get id():String
    {
        return _name.split("/")[1];
    }

    public function toString():String
    {
        return _name;
    }
}
}
