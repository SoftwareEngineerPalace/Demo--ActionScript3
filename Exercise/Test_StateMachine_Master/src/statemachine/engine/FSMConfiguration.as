package statemachine.engine
{
import org.robotlegs.core.IInjector;

import robotlegs.bender.framework.api.IInjector;

import statemachine.engine.api.*;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.StateMachineDriver;
import statemachine.engine.impl.StateMachineEngine;
import statemachine.engine.impl.StateMachineProperties;
import statemachine.engine.impl.StateProvider;
import statemachine.engine.impl.TransitionInspector;

public class FSMConfiguration
{
    internal var injector:org.robotlegs.core.IInjector

    public function FSMConfiguration( injector:IInjector )
    {
        this.injector = injector.createChild();
    }

    public function configure():void
    {
        injector.map( IInjector ).toValue( injector );
        injector.map( StateProvider ).asSingleton();
        injector.map( StateMachineProperties ).asSingleton();
        injector.map( StateDispatcher ).asSingleton();
        injector.map( StateMachineEngine ).asSingleton();
        injector.map( TransitionInspector );

        const dispatcher:FSMDispatcher = injector.getOrCreateNewInstance( StateDispatcher );
        injector.parent.map( FSMDispatcher ).toValue( dispatcher );

        const builder:FSMBuilder = injector.instantiateUnmapped( FSMBuilder );
        injector.parent.map( FSMBuilder ).toValue( builder );

        const fsm:StateMachine = injector.instantiateUnmapped( StateMachineDriver );
        injector.parent.map( StateMachine ).toValue( fsm );

    }


}
}
