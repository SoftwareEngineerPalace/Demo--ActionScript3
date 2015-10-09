package statemachine.engine.impl
{
public class State
{
    public static const NULL:State = new State("NULL");

    private var _name:String;
    private var _targetMap:Vector.<String>;
    private var _entryGuards:Vector.<Class>;
    private var _exitGuards:Vector.<Class>;

    public function State( name:String )
    {
        _name = name;
    }

    public function get name():String
    {
        return _name;
    }

    public function addTarget( stateName:String ):Boolean
    {
        if ( hasTarget( stateName ) )return false;
        _targetMap.push( stateName );
        return true;
    }

    public function hasTarget( stateName:String ):Boolean
    {
        const map:Vector.<String> = _targetMap || (_targetMap = new Vector.<String>());
        return (map.indexOf( stateName ) != -1);
    }

    public function addEntryGuard( guardClass:Class ):void
    {
        entryGuards.push( guardClass );
    }

    public function addExitGuard( guardClass:Class ):void
    {
        exitGuards.push( guardClass );
    }

    public function get entryGuards():Vector.<Class>
    {
        return _entryGuards || ( _entryGuards = new Vector.<Class>() );
    }

    public function get exitGuards():Vector.<Class>
    {
        return _exitGuards || ( _exitGuards = new Vector.<Class>() );
    }

    public function toString():String
    {
        return _name;
    }

}
}
