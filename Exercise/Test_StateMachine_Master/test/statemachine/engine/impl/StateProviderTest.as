package statemachine.engine.impl
{

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.support.StateName;

public class StateProviderTest
{
    private var _classUnderTest:StateProvider;


    [Before]
    public function before():void
    {
        _classUnderTest = new StateProvider();
    }

    [After]
    public function after():void
    {
        _classUnderTest = null;
    }

    [Test]
    public function hasState_returns_false_when_no_states_registered():void
    {
        assertThat(
                _classUnderTest.hasState( StateName.CLIENT ),
                isFalse()
        )
    }

    [Test]
    public function getState_returns_IState():void
    {
        assertThat(
                _classUnderTest.getState( StateName.CLIENT ),
                instanceOf( State )
        );
    }

    [Test]
    public function getState_returns_IState_with_given_name():void
    {
        assertThat(
                _classUnderTest.getState( StateName.CLIENT ).name,
                equalTo( StateName.CLIENT )
        );
    }

    [Test]
    public function hasState_returns_true_when_a_state_has_previously_been_registered():void
    {
        _classUnderTest.getState( StateName.CLIENT );
        assertThat(
                _classUnderTest.hasState( StateName.CLIENT ),
                isTrue()
        )
    }

    [Test]
    public function getState_always_returns_same_instance_for_a_given_name():void
    {
        assertThat(
                _classUnderTest.getState( StateName.CLIENT ),
                strictlyEqualTo( _classUnderTest.getState( StateName.CLIENT ) )
        );
    }

}
}
