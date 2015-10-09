package statemachine.engine.impl
{
import statemachine.engine.api.CancellationReason;

public class Approval
{
    private var _reason:CancellationReason = CancellationReason.NULL;
    private var _approved:Boolean;

    public function Approval( results:Boolean = true, reason:CancellationReason = null )
    {
        _approved = results;
        _reason = reason || CancellationReason.NULL;
    }

    public function get reason():CancellationReason
    {
        return _reason;
    }

    public function get approved():Boolean
    {
        return _approved;
    }
}
}
