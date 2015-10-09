package statemachine.engine.impl
{

import flash.utils.Dictionary;

public class StateProvider
{
    private const _registry:Dictionary = new Dictionary( false );

    public function hasState( name:String ):Boolean
    {
        return (_registry[name] != null );
    }

    public function getState( name:String ):State
    {
        if ( hasState( name ) ) return _registry[name];
        return _registry[name] = createState( name );
    }

    private function createState( name:String ):State
    {
        return new State( name );
    }
}
}
