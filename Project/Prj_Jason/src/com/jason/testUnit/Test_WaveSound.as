package com.jason.testUnit
{
	import com.vox.gospel.media.WaveSound;
	
	import flash.events.Event;

	public class Test_WaveSound
	{
		private static var _waveSound:WaveSound ;
		
		public function Test_WaveSound()
		{
			
		}
		
		public static function excute():void
		{
			_waveSound = new WaveSound();      
			_waveSound.addEventListener( WaveSound.EVENT_PLAY_OVER, function( $evt:Event ):void
			{
				$evt.currentTarget.removeEventListener( $evt.type, arguments.callee ) ;
				if ( _waveSound == $evt.currentTarget ) _waveSound = null;
			}
			) ;
			_waveSound.loadAndPlay("http://cdn-static-shared.test.17zuoye.net//fs-tts/546eb82cce23505c08000068");
		}
		
		public static function stopSound():void
		{
			_waveSound.stopSound() ;
		}
	}
}