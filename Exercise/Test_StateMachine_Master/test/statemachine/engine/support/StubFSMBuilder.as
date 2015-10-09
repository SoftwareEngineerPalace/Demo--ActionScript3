package statemachine.engine.support
{
import statemachine.engine.api.FSMBuilder;
import statemachine.engine.builders.StateBuilder;

public class StubFSMBuilder extends FSMBuilder
{
    public function StubFSMBuilder()
    {
        super(null);
    }

    override public function configure( stateName:String ):StateBuilder
    {
        return null;
    }
}
}
