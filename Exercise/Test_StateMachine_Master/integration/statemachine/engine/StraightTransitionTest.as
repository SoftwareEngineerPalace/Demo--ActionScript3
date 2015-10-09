package statemachine.engine
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;

import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.RobotlegsInjector;

import statemachine.engine.api.FSMBuilder;
import statemachine.engine.api.StateMachine;
import statemachine.support.StateName;
import statemachine.support.guards.GrumpyStateGuard;
import statemachine.support.guards.HappyStateGuard;

public class StraightTransitionTest
{
    private var _injector:IInjector;
    private var _configuration:FSMConfiguration;
    private var _builder:FSMBuilder;
    private var _fsm:StateMachine;

    [Before]
    public function before():void
    {
        _injector = new RobotlegsInjector();
        _injector.map( IInjector ).toValue( _injector );
        _configuration = _injector.instantiateUnmapped( FSMConfiguration );
        _configuration.configure();
        _builder = _injector.getInstance( FSMBuilder );
        _fsm = _injector.getInstance( StateMachine );
    }

    [Test]
    public function no_guards_all_targets_declared():void
    {
        _builder
                .configure( StateName.ONE )
                .withTargets( StateName.TWO )
                .and
                .configure( StateName.TWO )
                .withTargets( StateName.THREE )
                .and
                .configure( StateName.THREE )
                .withTargets( StateName.ONE );

        _fsm.changeState( StateName.ONE );
        _fsm.changeState( StateName.TWO );
        _fsm.changeState( StateName.THREE );

        assertThat( _fsm.properties.currentState, equalTo( StateName.THREE ) );
    }

    [Test]
    public function no_guards_missing_target_declaration():void
    {
        _builder
                .configure( StateName.ONE )
                .and
                .configure( StateName.TWO )
                .withTargets( StateName.THREE )
                .and
                .configure( StateName.THREE )
                .withTargets( StateName.ONE );

        _fsm.changeState( StateName.ONE );
        _fsm.changeState( StateName.TWO );
        _fsm.changeState( StateName.THREE );

        assertThat( _fsm.properties.currentState, equalTo( StateName.ONE ) );
    }

    [Test]
    public function all_happy_guards_targets_all_declared():void
    {
        _builder
                .configure( StateName.ONE )
                .withTargets( StateName.TWO )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard )
                .and
                .configure( StateName.TWO )
                .withTargets( StateName.THREE )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard )
                .and
                .configure( StateName.THREE )
                .withTargets( StateName.ONE )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard );


        _fsm.changeState( StateName.ONE );
        _fsm.changeState( StateName.TWO );
        _fsm.changeState( StateName.THREE );

        assertThat( _fsm.properties.currentState, equalTo( StateName.THREE ) );
    }

    [Test]
    public function grumpy_entry_guard_for_State_THREE_targets_all_declared():void
    {
        _builder
                .configure( StateName.ONE )
                .withTargets( StateName.TWO )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard )
                .and
                .configure( StateName.TWO )
                .withTargets( StateName.THREE )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard )
                .and
                .configure( StateName.THREE )
                .withTargets( StateName.ONE )
                .withEntryGuards( GrumpyStateGuard )
                .withExitGuards( HappyStateGuard );


        _fsm.changeState( StateName.ONE );
        _fsm.changeState( StateName.TWO );
        _fsm.changeState( StateName.THREE );

        assertThat( _fsm.properties.currentState, equalTo( StateName.TWO ) );
    }

    [Test]
    public function grumpy_extit_guard_for_State_TWO_targets_all_declared():void
    {
        _builder
                .configure( StateName.ONE )
                .withTargets( StateName.TWO )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard )
                .and
                .configure( StateName.TWO )
                .withTargets( StateName.THREE )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( GrumpyStateGuard )
                .and
                .configure( StateName.THREE )
                .withTargets( StateName.ONE )
                .withEntryGuards( HappyStateGuard )
                .withExitGuards( HappyStateGuard );


        _fsm.changeState( StateName.ONE );
        _fsm.changeState( StateName.TWO );
        _fsm.changeState( StateName.THREE );

        assertThat( _fsm.properties.currentState, equalTo( StateName.TWO ) );
    }


}
}
