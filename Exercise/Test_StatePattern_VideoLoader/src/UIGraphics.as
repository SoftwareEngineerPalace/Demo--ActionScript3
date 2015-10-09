package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	public class UIGraphics extends Sprite
	{
		
		private var uiButtonArray:Array;
		
		public function UIGraphics()
		{
			uiButtonArray = new Array;
		}
		
		public function addButtons(buttons:Array):Array{	
			
			for(var i:Number = 0; i<buttons.length;i++){
				var button:SimpleButton = buttons[i] as SimpleButton;
				button = new SimpleButton(this.buttonGraphic());
				button.name = buttons[i];
				uiButtonArray.push(button);
				addChild(button);
				button.y = i * (button.height + 4); 
				trace(button.name);
			}
			
			return uiButtonArray;
			
		}
		
		
		private function buttonGraphic():Sprite{
			var square:Sprite = new Sprite();
			//addChild(square);
			square.graphics.lineStyle(3,0x00ff00);
			square.graphics.beginFill(0x0000FF);
			square.graphics.drawRect(0,0,75,25);
			square.graphics.endFill();	
			return square;
		}
		
		
	}//end Class
}//end Package