package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[SWF(width="740",height="400",backgroundColor="0x444400")]
	public class EventFlowTest extends Sprite
	{
		public function EventFlowTest()
		{
			initView();
		}
		
		private function initView():void
		{
			//outer
			var outer:Sprite= new Sprite();
			outer.name="Outer";
			outer.graphics.beginFill(0xFF0000);
			outer.graphics.drawRect(0,0,100,100);
			outer.graphics.endFill() ;
			
			//mid
			var mid:Sprite = new Sprite();
			mid.name="mid"
			mid.graphics.beginFill(0x00FF00);
			mid.graphics.drawRect(0,0,50,50);
			mid.graphics.endFill() ;
			
			//inner
			var inner:Sprite = new Sprite();
			inner.name="inner";
			inner.graphics.beginFill(0x0000FF);
			inner.graphics.drawRect(0,0,25,25);
			inner.graphics.endFill() ;
			
			//addChild
			addChild(outer);
			outer.addChild(mid);
			mid.addChild(inner);
			outer.x = outer.y = 200 ;
			
			//添加侦听器
			outer.addEventListener( MouseEvent.MOUSE_DOWN,mouseDownHandler);
			inner.addEventListener( MouseEvent.MOUSE_DOWN,mouseDownHandler);
			mid.addEventListener( MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			trace("事件流当前阶段:" + evt.eventPhase ) ;
			trace("鼠标点击处最内层的显示对象(target)是:" + evt.target.name ) ;
			trace("事件当前流经显示对象(currentTarget)是:" + evt.currentTarget.name ) ;
			trace("===============================================================")
		}
	}
}