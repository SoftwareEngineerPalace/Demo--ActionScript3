package
{
	import flash.display.Sprite;
	import flash.events.ActivityEvent;
	import flash.events.StatusEvent;
	import flash.events.TextEvent;
	import flash.media.Microphone;
	import flash.text.TextField;
	
	import ghostcat.ui.controls.GText;
	
	public class JasonMain extends Sprite
	{
		public function JasonMain()
		{
			//testArrayReverst();
			
			//testLadderQuiz();
			
			//testMicrophone();
			
			//testHtmlText();
			
			testDate();
		}
		
		private function testDate():void
		{
			var date:Date = new Date();
			date.time = 1456761600000 ;
			var str:String = ( date.fullYear + "年" + ( date.month + 1 ) + "月" + date.dayUTC + "日" ).toString(); 
		}
		
		private function testHtmlText():void
		{
			var txt:GText = new GText();
			/*txt.multiline = true ;
			txt.width = 700;
			txt.height = 470;
			txt.wordWrap = true;*/
			txt.textField.htmlText = '<TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="SimHei" SIZE="21" COLOR="#825106" LETTERSPACING="0" KERNING="0">1. 请下载手机版, 手机做作业录音效果更好。</FONT></P></TEXTFORMAT><TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="SimHei" SIZE="21" COLOR="#825106" LETTERSPACING="0" KERNING="0">2. 没有手机，点击 “<FONT COLOR="#0000FF"><A HREF="event:checkmic" TARGET="">检测麦克风</A></FONT>” 调试您的电脑。<FONT COLOR="#0000FF"><A HREF="event:checkmic" TARGET=""></A></FONT></FONT></P></TEXTFORMAT><TEXTFORMAT LEADING="2"><P ALIGN="LEFT"><FONT FACE="SimHei" SIZE="21" COLOR="#825106" LETTERSPACING="0" KERNING="0">3. 没有手机，点击 “<FONT COLOR="#0000FF"><A HREF="event:nomic" TARGET="">听读模式</A></FONT>” 完成作业分数为60分。<FONT COLOR="#0000FF"><A HREF="event:nomic" TARGET=""></A></FONT></FONT></P></TEXTFORMAT>';
			//txt.textField.htmlText = '<html><p align="left"><a align="left">1. 请下载手机版, 手机做作业录音效果更好。</a></p><p align="left">2. 没有手机，点击 “<a align="left" href="event:checkmic"><font size="12" color="#0000FF">检测麦克风</font></a>” 调试您的电脑。</p><p align="left">3. 没有手机，点击 “<a align="left" href="event:nomic"><font size="12" color="#0000FF">听读模式</font></a>” 完成作业分数为60分。</p></html>';
			txt.textField.mouseEnabled = true ;
			txt.addEventListener( TextEvent.LINK, this.onTextLink );
			addChild( txt ) ;
		}
		
		private function onTextLink( $evt:TextEvent ):void
		{
			trace( $evt.text ) ;
		}
		
		private function testArrayReverst():void
		{
			var arrA:Array = [ "1","2","3","4"];
			trace( "arrA: " + arrA );
			var arrB:Array = arrA.reverse() ;
			trace( "arrA:　" + arrA ) ;　
			trace( "arrB:　" + arrB ) ;　
		}
		
		private function testMicrophone():void
		{
			var deviceArray:Array = Microphone.names;
			trace("Available sound input devices:");
			for (var i:int = 0; i < deviceArray.length; i++)
			{
				trace(" " + deviceArray[i]);
			}
			var mic:Microphone = Microphone.getMicrophone();
			mic.gain = 60;
			mic.rate = 11;
			mic.setUseEchoSuppression(true);
			mic.setLoopBack(true);
			mic.setSilenceLevel(5, 100);
			mic.addEventListener(ActivityEvent.ACTIVITY, onMicActivity);
			mic.addEventListener(StatusEvent.STATUS, onMicStatus);
			var micDetails:String = "Sound input device name: " + mic.name + '\n';
			micDetails += "Gain: " + mic.gain + '\n';
			micDetails += "Rate: " + mic.rate + " kHz" + '\n';
			micDetails += "Muted: " + mic.muted + '\n';
			micDetails += "Silence level: " + mic.silenceLevel + '\n';
			micDetails += "Silence timeout: " + mic.silenceTimeout + '\n';
			micDetails += "Echo suppression: " + mic.useEchoSuppression + '\n';
			trace(micDetails);
			function onMicActivity(event:ActivityEvent):void
			{
				trace("activating=" + event.activating + ", activityLevel=" +
					mic.activityLevel);
			}
			function onMicStatus(event:StatusEvent):void
			{
				trace("status: level=" + event.level + ", code=" + event.code);
			}
		}
		
		
	
		/**
		 * 测试阶梯问题
		 */
		private function testLadderQuiz():void
		{
			// 1 2 3 4 5 6  7  8  9  10 11  12
			// 1 2 3 5 8 13 21 34 55 89 144 233
			trace( "有 12  级台阶: " + fibonacci_solution2_storage( 6 ) );
			//trace( "有4级台阶: " + getMethodNum( 4 ) );
			//trace( "有5级台阶: " + getMethodNum( 5 ) );
			//trace( "有6级台阶: " + getMethodNum( 6 ) );
			trace( "执行次数: " + _times ) ;
		}
		
		private var _times:uint ;
		/**用递归的算法来求*/
		private function fibonacci_solution1_recursive( $floorNum:uint ):uint
		{
			_times ++ ;
			var result:uint ;
			var tmp:Array = [1,2];
			if( $floorNum < 2 )
				result = tmp[ $floorNum ]
			result = fibonacci_solution1_recursive( $floorNum - 1 ) + fibonacci_solution1_recursive( $floorNum - 2 ) ;
			return result ;
		}
		
		private function fibonacci_solution2_storage( $floorNum:uint ):uint
		{
			var result:Array = [0, 1];
			if( $floorNum < 2)
				return result[ $floorNum ] ;
			
			var fibNMinusBigger:uint = 2 ;
			var fibNMinusSmaller:uint = 1 ;
			var fibN :uint = 0 ;
			for( var i:uint = 2; i < $floorNum; i ++ )
			{
				_times ++ ;
				fibN = fibNMinusBigger + fibNMinusSmaller ;
				fibNMinusSmaller = fibNMinusBigger ;
				fibNMinusBigger = fibN ;
			}
			return fibN;
		}
	}
}