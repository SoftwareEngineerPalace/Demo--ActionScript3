package com.vox.swfloader.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SWFLoaderView extends Sprite 
	{
		private var _view:SRC_SWFLoader ;
		
		public static const State_Normal        :int = 0 ;
		public static const State_Loading       :int = 1 ;
		public static const State_LoadFail      :int = 2 ;
		
		private var _width                       :Number = 0 ;
		private var _height                      :Number = 0 ;
		private var _loadingPercent              :Number = 0 ;
		private var _curState                    :int = State_Normal ;
		
		private var _reloadHandler               :Function ;
		
		public function set reloadHandler( $value:Function ):void
		{
			_reloadHandler = $value ;
		}
		
		public function get curState():int
		{
			return _curState ;
		}
		
		public function set curState( $value:int ):void
		{
			_curState = $value ;
			updateView( ) ;
		}
		
		public function get loadingPercent():Number
		{
			return _loadingPercent ;
		}
		
		public function set loadingPercent( $value:Number ):void
		{
			_loadingPercent = $value ;
			updateView() ;
		}
		
		public function SWFLoaderView( $width:Number, $height:Number, $reloadHandler:Function )
		{
			_width = $width ;
			_height = $height ;
			_reloadHandler = $reloadHandler ;
			
			initView();
			resize() ;  
			updateView() ;
		}
		
		/**调整布局*/
		private function resize():void
		{
			//设置背景宽高
			_view.background.width = _width ;
			_view.background.height = _height ;
			
			//重摆 reloadBtn
			_view.reloadBtn.x = ( _width - _view.reloadBtn.width ) * 0.5 ;
			_view.reloadBtn.y = ( _height - _view.reloadBtn.height ) * 0.5 ;
			
			//重摆 错误提示
			_view.notice.x = ( _width - _view.notice.width ) * 0.5 ;
			_view.notice.y = _view.reloadBtn.y - _view.notice.height - 20 ;
			
			//重摆loading条
			_view.loadingBar.x = _width * 0.5 ;
			_view.loadingBar.y = _view.reloadBtn.y + 150 ;
		}
		
		/**更新view进度条*/
		private function updateView():void
		{
			//更新加载进度
			var progress:int = int( _loadingPercent * 100 )　;
			_view.loadingBar.progressNum.text = progress ;
			_view.loadingBar.gotoAndStop( progress ) ;
			
			//状态设置
			switch( _curState )
			{
				case State_Normal:
					_view.reloadBtn.visible = false ;
					_view.notice.visible = false ;
					break;
				case State_Loading:
					_view.reloadBtn.visible = false ;
					_view.notice.visible = false ;
					break;
				case State_LoadFail:
					_view.reloadBtn.visible = true ;
					_view.notice.visible = true ;
					break;
			}
		}
		
		private function onReloadHandler( $evt:MouseEvent ):void
		{
			if( _reloadHandler != null ) _reloadHandler();
		}
		
		private function initView():void
		{
			_view = new SRC_SWFLoader();
			_view.loadingBar.stop() ;
			_view.reloadBtn.addEventListener( MouseEvent.CLICK, onReloadHandler ) ;
			addChild( _view ) ;
		}
		
		public function dispose():void
		{
			_view.reloadBtn.removeEventListener( MouseEvent.CLICK, onReloadHandler ) ;
			_reloadHandler = null ;
			if( this.parent != null )
			{
				parent.removeChild( this ) ;
			}
		}
	}
}