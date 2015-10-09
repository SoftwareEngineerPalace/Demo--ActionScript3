package statemachine.engine.api
{
import statemachine.engine.builders.StateBuilder;
import statemachine.engine.impl.StateProvider;

public class FSMBuilder
{
    private var stateRegistry:StateProvider;

    public function FSMBuilder( stateRegistry:StateProvider )
    {
        this.stateRegistry = stateRegistry;
    }

    public function configure( stateName:String ):StateBuilder
    {
        return  new StateBuilder(
                stateRegistry.getState( stateName ),
                this
        );
    }


}
}
