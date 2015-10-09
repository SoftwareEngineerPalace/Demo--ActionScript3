package statemachine.engine.api
{
public class CancellationReason
{
    public static const NULL:CancellationReason = new CancellationReason( "reason/null", "null cancellation reason" );

    private var _desc:String;

    public function CancellationReason( type:String, desc:String = "" )
    {
        _type = type;
        _desc = desc;
    }

    private var _type:String;

    public function get type():String
    {
        return _type;
    }

    public function equals( reason:CancellationReason ):Boolean
    {
        return reason.type == type;
    }

    public function toString():String
    {
        return _type;
    }

    public function get desc():String
    {
        return _desc;
    }
}
}
