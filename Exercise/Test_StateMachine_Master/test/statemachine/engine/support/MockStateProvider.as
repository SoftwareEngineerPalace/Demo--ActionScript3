package statemachine.engine.support
{
import statemachine.engine.impl.State;
import statemachine.engine.impl.StateProvider;

public class MockStateProvider extends StateProvider
{
    public var targetChecked:String;
    public var targetsGot:String;
    public var hasStateValue:Boolean;
    public var stateValue:State;

    override public function hasState( name:String ):Boolean
    {
        targetChecked = name;
        return hasStateValue;
    }

    override public function getState( name:String ):State
    {
        targetsGot = name;
        return stateValue;
    }

}
}
