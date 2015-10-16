package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	
	/**
	 * @author jishu
	 * 1. 修改特定对象的ContextMenu
	 * 2. 隐藏 buildInItems
	 * 3. 显示指定的 buildInItem
	 * 3. 添加 customItems
	 * 4. 控制 customItems点击效果
	 */
	public class TestContextMenu extends Sprite
	{
		private var _customContextMenu   :ContextMenu;
		private var menuLabel       :String = "Reverse Colors";
		private var _redRectangle    :Sprite;
		private var label           :TextField;
		private var size            :uint = 100;
		private var black           :uint = 0x000000;
		private var red             :uint = 0xFF0000;
		
		public function TestContextMenu() 
		{
			initialize1();
		}
		
		private function initialize1():void
		{
			// 1 修改特定对象的ContextMenu
			_customContextMenu = new ContextMenu();
			_redRectangle = new Sprite();
			_redRectangle.graphics.clear() ;
			_redRectangle.graphics.beginFill( 0x00ff00, 1 ) ;
			_redRectangle.graphics.drawCircle( 100, 100, 50 ) ;
			_redRectangle.graphics.endFill() ;
			addChild( _redRectangle ) ;
			_redRectangle.contextMenu = _customContextMenu ;
			
			//2  隐藏 buildInItems
			_customContextMenu.hideBuiltInItems() ;
			
			//3 显示指定的 buildInItem
			var defaultItems:ContextMenuBuiltInItems = _customContextMenu.builtInItems ;
			defaultItems.play = true ;
			defaultItems.loop = true ;
			defaultItems.forwardAndBack = true ;
			defaultItems.print = true ;
			defaultItems.quality = true ;
			defaultItems.rewind = true ;
			defaultItems.save = true ;
			defaultItems.zoom = true ;
			
			//4 添加 customItems
			var customItem:ContextMenuItem = new ContextMenuItem( "click me" ) ;
			_customContextMenu.customItems.push( customItem ) ;
			
			//5 控制 customItems点击效果
			customItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, selectCustomItemHandler ) ;
		}
		
		private function selectCustomItemHandler( $evt:ContextMenuEvent ):void
		{
			trace("test");
		}
		
		
		private function initialize():void
		{
			initView();
			
			_customContextMenu = new ContextMenu();
			
			removeDefaultItems();
			addCustomMenuItems();
			_customContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
			
			_redRectangle.contextMenu = _customContextMenu ;
		}
		
		
		/**
		 * 初始化场景
		 */
		private function initView():void 
		{
			_redRectangle = new Sprite( ) ;
			_redRectangle.graphics.beginFill( red ) ;
			_redRectangle.graphics.drawRect( 0, 0, size, size ) ;
			addChild( _redRectangle ) ;
			_redRectangle.x = _redRectangle.y = size ;
			label = new TextField() ;
			label.text = "Right Click" ;
			_redRectangle.addChild( label ) ;
			_redRectangle.mouseChildren = false ;
		}
		
		private function removeDefaultItems():void
		{
			_customContextMenu.hideBuiltInItems();
			var defaultItems:ContextMenuBuiltInItems = _customContextMenu.builtInItems;
			defaultItems.print = true ;
		}
		
		private function addCustomMenuItems():void 
		{
			var item:ContextMenuItem = new ContextMenuItem( menuLabel ) ;
			_customContextMenu.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, menuItemSelectHandler);
		}
		
		private function menuSelectHandler(event:ContextMenuEvent):void 
		{
			trace("a: " + event);
		}
		
		private function menuItemSelectHandler(event:ContextMenuEvent):void 
		{
			trace("menuItemSelectHandler: " + event);
			var textColor:uint = (label.textColor == black) ? red : black;
			var bgColor:uint = (label.textColor == black) ? black : red;
			_redRectangle.graphics.clear();
			_redRectangle.graphics.beginFill(bgColor);
			_redRectangle.graphics.drawRect(0, 0, size, size);
			label.textColor = textColor;
		}
	}
}