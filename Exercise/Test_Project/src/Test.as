package
{
	import com.vox.game.view.sub.TimerCompo;
	import com.vox.gospel.utils.NumberUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import ghostcat.ui.controls.GPercentBar;
	
	[SWF(width="700",height="470",frameRate="24",backgroundColor="0")]
	public class Test extends Sprite
	{
		private var _timer:Timer ;
		private var _main:TimerCompo ;
		private var _tf:TextField ;
		
		public function Test():void
		{
			//	testMultiply();
			//testSuffixZeroReg();
			testWriteUTFBytes();
			stage.addEventListener( MouseEvent.CLICK, start ) ;
		}
		
		
		private function testWriteUTFBytes():void
		{
			var byte:ByteArray = new ByteArray();
			byte.writeUTFBytes("钟"); //三个字节  utf-8
			//byte.position = 0;
			while(byte.bytesAvailable > 0){
				trace(byte.readByte());
			}
			trace("--");
			for(var i:int=0; i<byte.length; i++){
				trace(byte[i],byte[i].toString(16))
			}
		}
		
		private function uncaughtErrorDemo():void
		{
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			//recursion();	
		}
	
		private function start( $evt:MouseEvent ):void
		{
			recursion();
		}
		private var _flag:uint ;
		protected function recursion(depth:uint=0):void
		{
			if (depth == 5 )
			{
				throw new Error( "error01" ) ;
			}
			else
			{
				trace( "depth: " + (++depth) );
				//_flag = setTimeout( recursion, 1, depth ) ;
				recursion( depth );
			}
		}
		
		protected function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			trace("A:" + Error(event.error).getStackTrace());
			trace("B:" + event.error.getStackTrace());
		}
		
		private var _suffixZeroRegExp     :RegExp = /(0+)$/g ;
		private function testSuffixZeroReg():void
		{
			var str:String = "d12210" ;
			var tmp:Array = _suffixZeroRegExp.exec( str ) ;
			trace();
		}
		
		private function testMultiply():void
		{
			var dividend:Number = 122.1000002 ;
			var dot:int = 2 ;
			
			var result:Number = NumberUtils.round( dividend, Math.pow( 1/10, dot ) ) ;
			trace("");
		}
		
		private var _noneZeroRegExp:RegExp = /[^0]+/g ;
		public function regExp_exec():void
		{
			var test:String = "500" ;
			test = get_str_none_preAndsuf_zero( test );
			
			return ;
			var reg:RegExp = /a{1,5}/g;
			var testStr:String = "54545adf98954aaaa454aa899uj9" ;
			trace( reg.exec( testStr ) );
			trace( reg.exec( testStr ) );
			trace( reg.exec( testStr ) );
		}
		
		private function get_str_none_preAndsuf_zero( $value:String ):String
		{
			for (var i:int = 0, len:uint = $value.length ; i < len; i++) 
			{
				if( $value.charAt( i ) != "0" )
				{
					$value = $value.slice( i ) ;
					break; 
				}
			}
			
			for (var j:int = $value.length - 1 ; j >= 0 ; j -- ) 
			{
				if( $value.charAt( j ) != "0" )
				{
					$value = $value.slice( 0, j + 1 ) ;
					break; 
				}
			}
			return $value ;
		}
		
		
		public function Array_filter():void
		{
			var employees:Array = new Array();
			employees.push({name:"Employee 1", manager:false});
			employees.push({name:"Employee 2", manager:true});
			employees.push({name:"Employee 3", manager:false});
			trace("Employees:");
			employees.forEach(traceEmployee);
			
			var managers:Array = employees.filter(isManager);
			trace("Managers:");
			managers.forEach(traceEmployee);
		}
		
		private function isManager(element:*, index:int, arr:Array):Boolean 
		{
			return (element.manager == true);
		}
		
		private function traceEmployee(element:*, index:int, arr:Array):void {
			trace("\t" + element.name + ((element.manager) ? " (manager)" : ""));
		}
		
		public function array_map():void
		{
			var arr:Array = new Array("one", "two", "Three");
			trace(arr); // one,two,Three
			
			var upperArr:Array = arr.map(toUpper);
			trace(upperArr); // ONE,TWO,THREE
		}
		private function toUpper(element:*, index:int, arr:Array):String {
			return String(element).toUpperCase();
		}
		
		
		public function array_some():void
		{
			var arr1:Array = [ 1, 3, "a", 8 ] ;
			var res1:Boolean = arr1.every( isNumeric2 ) ;
			trace( res1 ) ;
		}
		
		private function isNumeric2( $element:*, $index:int, $arr:Array ):Boolean
		{
			var result:Boolean ;
			if( $element is Number ) 
				result =  true ;
			return result ;
		}
		
		public function array_every():void
		{
			var arr1:Array = new Array(1, 2, 4);
			var res1:Boolean = arr1.every(isNumeric);
			trace("isNumeric:", res1); // true
			
			var arr2:Array = new Array(1, 2, "ham");
			var res2:Boolean = arr2.every(isNumeric);
			trace("isNumeric:", res2); // false
		}
		
		private function isNumeric(element:*, index:int, arr:Array):Boolean 
		{
			return (element is Number);
		}
		
		/**
		 * 练习三
		 * 深复制
		 */
		private function copyArray():void
		{
			var arr0:Array = [ 2,9,4,0];
			//var arr1:Array = arr0.reverse() ;
			trace( arr0.sort( sortOption ) ) ;
			trace( arr0 ) ;
		}
		
		private function sortOption( $param0:Object, $param1:Object ):int
		{
			var result:int ;
			if( $param0 > $param1 )
			{
				result =  - 1 ;
			}
			else if( $param0 < $param1 )
			{
				result = 1 ;
			}
			else
			{
				result = 0 ;
			}
			return result ;
		}
		
		/**
		 * 练习二
		 * @return 
		 */
		public function array_lastIndexOf():void
		{
			var arr:Array = new Array(123,45,6789,123,984,323,123,32);
			
			var index:int = arr.indexOf(123);
			trace(index); // 0
			
			var index2:int = arr.lastIndexOf(123,5);
			trace(index2); // 6
		}
		
		/**
		 * 练习一
		 */
		private function testGPercentBar():void
		{
			_main = new TimerCompo();
			_main.pbr_time.minValue = 1 ;
			_main.pbr_time.maxValue = 48 ;
			_main.pbr_time.mode = GPercentBar.MOVIECLIP ;
			_main.pbr_time.setPercent( 0 ) ;
			addChild( _main );
			_main.btn_start.addEventListener( MouseEvent.CLICK, btn_start_clickHandler ) ;
			
			var str:String = "1343";
			var result:uint = str.split(".")[1].length;
			trace();
		}
		
		private function btn_start_clickHandler( $evt:MouseEvent ):void
		{
			startTimer() ;
		}
		
		private function onTimer(event:TimerEvent):void
		{
			trace("percent: " +  _timer.currentCount / _timer.repeatCount  );
			_main.pbr_time.setPercent( _timer.currentCount / _timer.repeatCount, true ) ;
		}
		
		private function onTimeComplete(event:TimerEvent):void
		{
			trace("到时间");
		}
		
		private function startTimer():void
		{
			if( !_timer )
			{
				_timer = new Timer( 2000, 20 ) ;
				_timer.addEventListener( TimerEvent.TIMER, onTimer ) ;
				_timer.addEventListener( TimerEvent.TIMER_COMPLETE, onTimeComplete ) ;
				_timer.start() ;
			}
		}
		
		private function disposeTimer():void
		{
			if( _timer )
			{
				_timer.removeEventListener( TimerEvent.TIMER, onTimer ) ;
				_timer.removeEventListener( TimerEvent.TIMER_COMPLETE, onTimeComplete ) ;
				_timer.stop() ;
			}
			_timer = null ;
		}
	}
}