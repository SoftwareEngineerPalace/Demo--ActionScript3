/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package 
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Security;
	
	import org.robotlegs.demos.flashgooglemaps.FlashGoogleMapsContext;
	
	public class FlashGoogleMaps extends Sprite
	{
		// hold on to this
		private var _context:FlashGoogleMapsContext;
		
		public static const GOOGLE_MAPS_API_KEY:String = "ABQIAAAAO-cCleAenkHS3l5YIe2rfxSt3J1WxB__3gt1bNGcz4st1p409RRCt9eMECH2W2XImEESSkQKpJMumg";
		public static const GOOGLE_MAPS_URL:String = "http://robotlegs.org";
		
		public function FlashGoogleMaps()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Security.allowDomain("maps.googleapis.com");
			
			// initialize the framework
			_context = new FlashGoogleMapsContext(this);
		}
	}
}