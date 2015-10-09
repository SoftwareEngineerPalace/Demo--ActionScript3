package statemachine.engine.api
{
import org.hamcrest.assertThat;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isTrue;

import statemachine.engine.builders.StateBuilder;

import statemachine.engine.impl.StateProvider;
import statemachine.engine.api.FSMBuilder;
import statemachine.support.StateName;

public class FSMBuilderTest
{
    private var _classUnderTest:FSMBuilder;
    private var _registry:StateProvider;


    [Before]
    public function before():void
    {
        _registry = new StateProvider();
        _classUnderTest = new FSMBuilder( _registry );
    }

    [Test]
    public function configureState_returns_instance_of_StateBuilder():void
    {
        assertThat( _classUnderTest.configure( StateName.CLIENT ), instanceOf( StateBuilder ) );
    }

    [Test]
    public function configureState_creates_new_state():void
    {
        _classUnderTest.configure( StateName.CLIENT );
        assertThat( _registry.hasState( StateName.CLIENT ), isTrue() );
    }



}
}
