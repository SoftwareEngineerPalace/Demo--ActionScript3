package com.jason.timertool.enterframe
{
	/**
	 * list接口
	 * */
    public interface List
	{
        public function List();
        function size() : int;
        function shift():Object ;
        function isEmpty() : Boolean;
        function remove(param1:Object):Object;
        function replaceAt(param1:int, param2:Object):Object;
        function indexOf(param1:Object) : int;
        function clear() : void;
        function appendAll(param1:Array, param2:int = -1) : void;
        function first():Object;
        function pop():Object ;
        function get(param1:int):Object ;
        function removeAt(param1:int):Object ;
        function appendList(param1:List, param2:int = -1) : void;
        function removeRange(param1:int, param2:int) : Array;
        function append(param1:Object, param2:int = -1) : void;
        function last():Object ;
        function toArray() : Array;
        function contains(param1:Object) : Boolean;
    }
}
