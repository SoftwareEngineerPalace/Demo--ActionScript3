package com.jason.timertool.enterframe
{
    public class ArrayList extends Object implements List
	{
        protected var _elements             :Array;
        public static const CASEINSENSITIVE:int = 1;
        public static const NUMERIC        :int = 16;
        public static const RETURNINDEXEDARRAY:int = 8;
        public static const DESCENDING     :int = 2;
        public static const UNIQUESORT     :int = 4;

        public function ArrayList()
		{
            _elements = new Array();
            return;
        }

        public function sort(param1:Object, param2:int) : Array
        {
            return _elements.sort(param1, param2);
        }

        public function eachFun(param1:Function) : void
        {
            var _loc_2:int = 0;
            while (_loc_2 < _elements.length)
            {
                param1(_elements[_loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }

        public function shift():Object
        {
            if (size() > 0)
            {
                return _elements.shift();
            }
            return undefined;
        }

        public function remove(param1:Object):Object
        {
            var _loc_2:* = indexOf(param1);
            if (_loc_2 >= 0)
            {
                return removeAt(_loc_2);
            }
            return null;
        }

        public function indexOf(param1:Object) : int
        {
            var _loc_2:int = 0;
            while (_loc_2 < _elements.length)
            {
                if (_elements[_loc_2] === param1)
                {
                    return _loc_2;
                }
                _loc_2 = _loc_2 + 1;
            }
            return -1;
        }

        public function isEmpty() : Boolean
        {
            if (_elements.length > 0)
            {
                return false;
            }
            return true;
        }

        public function setElementAt(param1:int, param2:Object) : void
        {
            replaceAt(param1, param2);
            return;
        }

        public function eachWithout(param1:Object, param2:Function) : void
        {
            var _loc_3:int = 0;
            while (_loc_3 < _elements.length)
            {
                if (_elements[_loc_3] != param1)
                {
                    param2(_elements[_loc_3]);
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }

        public function elementAt(param1:int):Object
        {
            return get(param1);
        }

        public function pop():Object
        {
            if (size() > 0)
            {
                return _elements.pop();
            }
            return null;
        }

        public function lastIndexOf(param1:Object) : int
        {
            var _loc_2:* = _elements.length - 1;
            while (_loc_2 >= 0)
            {
                if (_elements[_loc_2] === param1)
                {
                    return _loc_2;
                }
                _loc_2 = _loc_2 - 1;
            }
            return -1;
        }

        public function clear() : void
        {
            if (!isEmpty())
            {
                _elements.splice(0);
                _elements = new Array();
            }
            return;
        }

        public function removeAt(param1:int):Object
        {
            var _loc_2:Object = null;
            if (param1 >= 0)
            {
            }
            if (param1 >= size())
            {
                return null;
            }
            _loc_2 = _elements[param1];
            _elements.splice(param1, 1);
            return _loc_2;
        }

        public function appendList(param1:List, param2:int = -1) : void
        {
            appendAll(param1.toArray(), param2);
            return;
        }

        public function append(param1:Object, param2:int = -1):void
        {
            if (param2 == -1)
            {
                _elements.push(param1);
            }
            else
            {
                _elements.splice(param2, 0, param1);
            }
            return;
        }

        public function replaceAt(param1:int, param2:Object):Object
        {
            var _loc_3:Object = null;
            if (param1 >= 0)
            {
            }
            if (param1 >= size())
            {
                return null;
            }
            _loc_3 = _elements[param1];
            _elements[param1] = param2;
            return _loc_3;
        }

        public function removeRange(param1:int, param2:int) : Array
        {
            param1 = Math.max(0, param1);
            param2 = Math.min(param2, (_elements.length - 1));
            if (param1 > param2)
            {
                return [];
            }
            return _elements.splice(param1, param2 - param1 + 1);
        }

        public function size() : int
        {
            return _elements.length;
        }

        public function get(param1:int):Object 
        {
            return _elements[param1];
        }

        public function contains(param1:Object) : Boolean
        {
            return indexOf(param1) >= 0;
        }

        public function toArray() : Array
        {
            return _elements.concat();
        }

        public function appendAll(param1:Array, param2:int = -1) : void
        {
            var _loc_3:Array = null;
            if (param1 != null)
            {
            }
            if (param1.length <= 0)
            {
                return;
            }
            if (param2 != -1)
            {
            }
            if (param2 == _elements.length)
            {
                _elements = _elements.concat(param1);
            }
            else if (param2 == 0)
            {
                _elements = param1.concat(_elements);
            }
            else
            {
                _loc_3 = _elements.splice(param2);
                _elements = _elements.concat(param1);
                _elements = _elements.concat(_loc_3);
            }
            return;
        }

        public function sortOn(param1:Object, param2:int) : Array
        {
            return _elements.sortOn(param1, param2);
        }

        public function clone() : ArrayList
        {
            var _loc_1:* = new ArrayList();
            var _loc_2:int = 0;
            while (_loc_2 < _elements.length)
            {
                
                _loc_1.append(_elements[_loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            return _loc_1;
        }

        public function last():Object
        {
            return _elements[(_elements.length - 1)];
        }

        public function subArray(param1:int, param2:int) : Array
        {
            return _elements.slice(param1, Math.min(param1 + param2, size()));
        }

        public function toString() : String
        {
            return "ArrayList : " + _elements.toString();
        }

        public function getSize() : int
        {
            return size();
        }

        public function first():Object
        {
            return _elements[0];
        }
    }
}
