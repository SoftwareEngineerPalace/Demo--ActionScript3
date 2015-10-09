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

package src.com.app
{//Package
	import fl.controls.UIScrollBar;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Jake Callery
	 */
	public class DebugViewer extends EventDispatcher
	{//DebugViewer Class
		
		private var _debugText:TextField;
		private var _debugScrollBar:UIScrollBar;
		
		public function DebugViewer($debugText:TextField, $debugScrollBar:UIScrollBar) 
		{//DebugViewer
			_debugText = $debugText;
			_debugScrollBar = $debugScrollBar;
		}//DebugViewer
		
		public function out($text:String):void
		{//out
			_debugText.appendText($text+"\n");
			_debugText.scrollV = _debugText.maxScrollV;
			_debugScrollBar.update();
		}//out
		
	}//DebugViewer Class

}//Package