package
{
	import com.vox.future.utils.FlashConsole;
	import com.vox.future.utils.KeyPasswordUtil;
	import com.vox.game.load.ISWFLoadProxyHandler;
	import com.vox.game.load.SWFLoadProxy;
	import com.vox.gospel.utils.LoadUtil;
	import com.vox.gospel.utils.PathUtil;
	import com.vox.swfloader.view.SWFLoaderView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * 功能 加载类
	 * @author 肖建军
	 */
	[SWF(width="700",height="400",backgroudColor="#ffffff", frameRate="24")]
	public class SWFLoaderApp extends Sprite implements ISWFLoadProxyHandler
	{
		private var _waitFlag                 :uint ;
		CONFIG::RELEASE
		private var _flashConsoleLoaded       :Boolean = false ;
		private var _loaderContext            :LoaderContext ;
		
		private var _view                     :SWFLoaderView ;
		
		private var _swfLoadProxy             :SWFLoadProxy ;
		
		public function SWFLoaderApp()
		{
			check_onAddedToStage();
		}
		
		private function check_onAddedToStage():void
		{
			if( stage != null ) 
			{
				onAddedTosStage();
			}
			else
			{
				addEventListener( Event.ADDED_TO_STAGE, onAddedTosStage ) ;
			}
		}
		
		private function onAddedTosStage( $evt:Event = null ):void
		{
			//1  设定Stage参数
			prevInitStageParameters();
			
			//2 初始化initFlashConsole
			initialize() ;
		}
		
		/**设定Stage参数*/
		private function prevInitStageParameters():void
		{
			stage.align = StageAlign.TOP_LEFT ;
			stage.scaleMode = StageScaleMode.NO_SCALE ;
		}
		
		private function initialize():void
		{
			//0   检查 IE某些版本浏览器下载设置了ScaleMode和Align后可能会导致无法获取舞台宽高，因此必须有下面的步骤
			if( _waitFlag > 0 ) 
			{
				clearTimeout( _waitFlag ) ;
				_waitFlag = 0 ;
			}
			if( stage.stageWidth * stage.stageHeight <= 0 )
			{
				_waitFlag = setTimeout( initialize, 100 ) ;
				return ;
			}
			//1  实时日志
			initFlashConsole() ;
			//2  右键菜单
			initContextMenu() ;
			//3 初始化view
			initView() ;
			
			startLoad();
		}
		
		private function startLoad():void
		{
			_view.curState = SWFLoaderView.State_Loading ;
			_swfLoadProxy = new SWFLoadProxy( stage, this, loaderInfo.parameters, "swfloader");
			_swfLoadProxy.startLoad();
		}
		
		private function reloadHandler():void
		{
			PathUtil.changeImgDomain( function( imgDomain:String ):void
			{
				_view.curState = SWFLoaderView.State_Loading ;
			});
		}
		
		private function initView():void
		{
			_view = new SWFLoaderView( stage.stageWidth, stage.stageHeight, reloadHandler ) ;
			addChild( _view ) ;
		}
		
		/**
		 * 初始化Flash Console
		 */
		private function initFlashConsole():void
		{
			CONFIG::DEVs
			{
				FlashConsole.initConsole( this ) ;
			}
			CONFIG::RELEASE
			{
				PathUtil.initialize( stage.loaderInfo.parameters ) ;
				KeyPasswordUtil.initialize( stage　) ;
				KeyPasswordUtil.addMap( "test", function():void
				{
					if( _flashConsoleLoaded ) return ;
					LoadUtil.loaderLoad( PathUtil.wrapFlashURL("assets/FlashConsolePack.swf?t=" + new Date().time ), function( $loader:Loader ):void
					{
						var pack:Sprite = $loader.content as Sprite ;
						pack["initialize"]( stage ) ;
						_flashConsoleLoaded = true ;
					},null,null,_loaderContext ) ;
				});
			}
		}
		
		/**
		 * 初始化右键菜单
		 */
		private function initContextMenu():void
		{
			var cm:ContextMenu = new ContextMenu();
			//关于一起作业 
			var aboutCMItem:ContextMenuItem = new ContextMenuItem( "关于一起作业" ) ;
			aboutCMItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onAbout17ZuoyeHandler ) ;
			cm.customItems.push( aboutCMItem ) ;
			
			//切换麦克风
			var microCMItem:ContextMenuItem = new ContextMenuItem( "切换麦克风" ) ;
			microCMItem.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, onChangeMicrophoneHandler ) ;
			cm.customItems.push( microCMItem ) ;
			
			//版本号
			var versionCMItm:ContextMenuItem = new ContextMenuItem( "SWFLoader-v" + CONFIG::VERSION ) ;
			versionCMItm.enabled = false ;
			cm.customItems.push( versionCMItm ) ;
			
			this.contextMenu = cm ;
		}
		
		/**打开 "关于" 页面*/
		private function onAbout17ZuoyeHandler( $evt:ContextMenuEvent ):void
		{
			navigateToURL( new URLRequest( this.loaderInfo.parameters.domain + "help/aboutus.api"), "_new" ) ;
		}
		
		/**显示切换麦克风的面板*/
		private function onChangeMicrophoneHandler( $evt:ContextMenuItem ):void
		{
			Security.showSettings( SecurityPanel.MICROPHONE ) ;
		}
		
		public function onGameEnd($result:Object):void
		{
			trace("SWFLoaderApp onGameEnd");
		}
		
		public function onLoadComplete( $game:DisplayObject):void
		{
			_view.curState = SWFLoaderView.State_Normal ;
			_loaderContext = _swfLoadProxy.loaderContext ;
			var parent:DisplayObjectContainer = parent ;
			//先移除自身
			dispose();
			//后添加子节点, 防止子节点访问以loader
			parent.addChild( Loader( $game ).content ) ;
			//通知js
			if( ExternalInterface.available )
			{
				ExternalInterface.call( "flashAppStartSuccessfully" ) ;
			}
		}
		
		public function onLoadError($evt:ErrorEvent):void
		{
			_view.curState = SWFLoaderView.State_LoadFail ;
		}
		
		public function onLoadProgress($url:String, $curIndex:int, $totalNum:uint, $numBytes:Number, $totalBytes:Number):void
		{
			_view.loadingPercent = $numBytes / $totalBytes ;
		}
		
		public function onLoadStart():void
		{
			trace( "开始加载了!" ) ;
		}
		
		private function dispose():void
		{
			if( parent != null )
			{
				parent.removeChild( this ) ;
			}
			if( _view != null ) 
			{
				_view.dispose();
			}
			_swfLoadProxy = null ;
		}
	}
}