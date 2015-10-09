package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.net.NetStream;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(backgroundColor="#666666", frameRate="100", width="800", height="450")]
	public class MediaStatePlayer extends Sprite
	{	
		private var button:ButtonState
		private var ui:UIGraphics;
		private var uiButtonArray:Array;
		
		private var loading:IVideoState;		
		private var playing:IVideoState;		
		private var waiting:IVideoState;
		
		private var _loadVideo:LoadVideo;	
		private var _state:IVideoState;
		
		public function MediaStatePlayer()
		{				
			init();
		}
		
		/**
		 * Loads the initial available states and listeners 
		 * 
		 */
		private function init():void{
			
			loading = new LoadingState(this);
			waiting = new WaitingState(this);
			playing = new PlayState(this);
			
			ui = new UIGraphics();			
			//GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_PLAYING, setStatePlaying);
			GlobalDispatcher.GetInstance().addEventListener(GlobalEvent.VIDEO_WAITING, setWaiting);			
			initVideo();			
		}		
			
		
		private function initVideo():void{	
			
			var buttonArray:Array = new Array()
			buttonArray = ["ortho","pedo","pedo2"];
			
			uiButtonArray = ui.addButtons(buttonArray);				
			addChild(ui);
			_loadVideo = new LoadVideo("http://k.youku.com/player/getFlvPath/sid/943986380742910a93de2_00/st/flv/fileid/0300020100549EA77D799902F1B7981C8D871C-4935-0CCC-119A-0AE41CFAB924?K=9c197f5b605aad1b24124f0e&ctype=10&ev=1&oip=2043096855&token=4129&ep=0PdMKbZq32Eo6bUeqQLstPy%2FohmiC886DJaH%2BcpJokH6WLyNvGPblRl0Yd8hF5lb2H2QXjtQFPNeHj%2FnTOCzm7CnVi3BJhcf8PEPqK52PHuZdSxX9R9J%2BGIjN8U68jgtHHrX9ucf1NU%3D&ymovie=1",800,400);
			_loadVideo.startPlayPercent = 15;
			addChild(_loadVideo.video);	
			
			state = loading;
			state.applyState();
			state.buttonState();
		}
				
		
		public function setPlaying():void{			
			state = playing;	
			state.applyState();	
			state.buttonState();//kept public for accessiblity of Flash IDE elements
		}
		
		private function setWaiting(event:GlobalEvent):void{
			state = waiting;
			state.applyState();			
		}
		
		
///////////////////////////////setters and getters//////////////////////
		
		public function get buttons():Array{			
			return uiButtonArray;
		}
		
		
		public function get video():LoadVideo{
			return _loadVideo; 
		}
		
		public function get videoStream():NetStream{
			return _loadVideo.stream;
		}
		
		
		public function set state(value:IVideoState):void{
			
			_state = value;
		}
		
		public function get state():IVideoState{
			
			return _state;
		}	
		
		
		
	}//end Class
}//end Package