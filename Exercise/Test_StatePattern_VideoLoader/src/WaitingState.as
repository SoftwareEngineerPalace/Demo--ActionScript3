package
{
	import flash.display.SimpleButton;
	
	
	public class WaitingState implements IVideoState
	{
		
		private var _media:MediaStatePlayer;
		
		public function WaitingState(msObject:MediaStatePlayer)
		{
			
			_media = msObject;
			trace("waiting state");	
			//trace(super.videoStream);			
		}
		
		public function applyState():void{			
			
		}
		
		
		public function buttonState():void{			
			for each (var button:SimpleButton in _media.buttons){
				button.mouseEnabled = true;	
				button.alpha = 1;
			}
		}
		
		
		
		
		
		
	}//end Class
}//end Package