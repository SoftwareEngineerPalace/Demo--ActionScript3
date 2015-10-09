package command
{
	
	public class LightOffCommand implements ICommand
	{
		private var _light:Light;
		
		public function LightOffCommand($light:Light)
		{
			_light = $light;
		}
		
		public function doAction():void
		{
			_light.off();
		}
		
		public function unDo():void
		{
			_light.open();
		}
		
	}
}