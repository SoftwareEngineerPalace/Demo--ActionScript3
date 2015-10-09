package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.net.NetStream;
	
	
	public class PlayState implements IVideoState
	{
		private var _media:MediaStatePlayer;
		
		public function PlayState(msObject:MediaStatePlayer)
		{	
			_media = msObject;
			trace("playing state");	
			//trace(super.videoStream);			
		}
		
		public function applyState():void{			
			_media.videoStream.resume();
			
		}
		
		public function buttonState():void{			
			for each (var button:SimpleButton in _media.buttons){
				
				button.mouseEnabled = false;	
				button.alpha = .5;
			}
		}
		
		
		
		
		
	}//end Class
}//end Package