/*
Copyright (c)2011 Hook L.L.C

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package com.app.events 
{//Packge
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class MicManagerEvent extends Event 
	{//MicManagerEvent Class

		static public const NEW_DATA:String = "micManagerNewData";
	
		private var _data:Object;
	
		public function MicManagerEvent(type:String, $data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{//MicManagerEvent 
			super(type, bubbles, cancelable);
			_data = $data;
		}//MicManagerEvent
		
		public override function clone():Event 
		{//clone
			return new MicManagerEvent(type, _data, bubbles, cancelable);
		}//clone 
		
		public override function toString():String 
		{//toString
			return formatToString("MicManagerEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}//toString
		
		public function get data():Object { return _data; }
		
	}//MicManagerEvent Class
	
}//Packge