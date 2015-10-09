package statemachine.engine
{
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

import statemachine.engine.api.*;
import statemachine.engine.impl.StateDispatcher;
import statemachine.engine.impl.StateMachineDriver;
import statemachine.engine.impl.StateMachineEngine;
import statemachine.engine.impl.StateMachineProperties;
import statemachine.engine.impl.StateProvider;
import statemachine.engine.impl.TransitionInspector;

public class StateMachineExtension implements IExtension
{

    public function extend( context:IContext ):void
    {
        const provider:StateProvider = new StateProvider();
        const stateMachineProps:StateMachineProperties = new StateMachineProperties();
        const dispatcher:StateDispatcher = new StateDispatcher();
        const inspector:TransitionInspector = new TransitionInspector( context.injector );
        const engine:StateMachineEngine = new StateMachineEngine( dispatcher, inspector );

        const builder:FSMBuilder = new FSMBuilder( provider );
        const driver:StateMachineDriver = new StateMachineDriver( engine, provider, stateMachineProps, dispatcher );

        context.injector.map( FSMBuilder ).toValue( builder );
        context.injector.map( StateMachine ).toValue( driver );
    }
}
}
