package
{
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	public class TestContextMenu01 extends Sprite
	{
		public function TestContextMenu01()
		{
			initView();
		}
		
		private function initView():void
		{
			//0 给指定对象添加ContextMenu
			var myContextMenu:ContextMenu = new ContextMenu();
			var spr:Sprite = new Sprite();
			spr.graphics.clear() ;
			spr.graphics.beginFill( 0xff0000, 1 );
			spr.graphics.drawCircle( 200, 200, 100 ) ;
			spr.graphics.endFill() ;
			addChild( spr ) ;
			spr.contextMenu = myContextMenu ;
			//1 隐藏buildInItem
			myContextMenu.hideBuiltInItems();
			//2 显示指定buildInItem
			myContextMenu.builtInItems.play = true ;
			myContextMenu.builtInItems.print = true ;
			//3 添加CustomItem
			var customItem:ContextMenuItem = new ContextMenuItem( "test" ) ;
			myContextMenu.customItems.push( customItem ) ;
			//4 给CustomItem添加点击监听
			customItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, customClickHandler )　;
		}
		
		private function customClickHandler( $evt:ContextMenuEvent ):void
		{
			trace("test");
		}
	}
}