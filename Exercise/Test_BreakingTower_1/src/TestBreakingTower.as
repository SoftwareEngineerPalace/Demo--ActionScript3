package
{
	import com.vox.future.Application;
	import com.vox.future.managers.ContextManager;
	import com.vox.future.managers.SceneManager;
	import com.vox.future.services.GameCommonService;
	import com.vox.game.breaktower.enum.PathConst;
	import com.vox.game.breaktower.mediator.scene.LoginSceneMediator;
	import com.vox.game.breaktower.mediator.ui.CommonUIMediator;
	import com.vox.game.breaktower.model.RoleModel;
	import com.vox.game.breaktower.net.MessageType;
	import com.vox.game.breaktower.net.message.InitInfoMessage;
	import com.vox.game.breaktower.pub.ModuleConst;
	import com.vox.game.breaktower.view.scene.LoginScene;
	import com.vox.game.breaktower.view.ui.CommonUI;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class TestBreakingTower extends Application
	{
		public function TestBreakingTower()
		{
			
		}
		
		override public function get bgMusic():*
		{
			// TODO Auto Generated method stub
			return 1 ;
		}
		
		override public function get bgMusicVolumn():Number
		{
			//暂没有需求
			return 1 ;
		}
		
		override public function listModuleDict():Dictionary
		{
			return ModuleConst.moduleDict;
		}
		
		override public function listCommandDict():Dictionary
		{
			var dict:Dictionary = MessageType.commandDict ;
			return dict ;
		}
		
		override public function listMediatorDict():Dictionary
		{
			var dict:Dictionary = new Dictionary();
			dict[LoginScene] = LoginSceneMediator;
			dict[CommonUI] = CommonUIMediator;
			return dict;
		}
		
		override public function listModelClasses():Array
		{
			return [ RoleModel ] ;
		}
		
		override public function listSingletonInjectors():Array
		{
			return super.listSingletonInjectors();
		}
		
		override public function get testFlashVars():Object
		{
			return{
				debug:true ,
				flashId:"Balel",
				domain:"http://www.test.17zuoye.net/",
				imgDomain:"http://cdn-static-shared.test.17zuoye.net/",
				flashUrl:"http://cdn-cc.test.17zuoye.net/resources/apps/flash/babel/Babel-V20150728200626.swf"
			}
		}
		
		override protected function get version():String
		{
			return CONFIG::VERSION ;
		}
		
		override public function initialize():void
		{
			super.initialize();
			//1 设置帧 
			stage.frameRate = 30 ;
			//2 初始化Path
			var service:GameCommonService = ContextManager.context.getObjectByType( GameCommonService ) ;
			PathConst.initializ( service.imgDomain ) ;
			//3 切入主场景
			var sceneManager:SceneManager = ContextManager.context.getObjectByType( SceneManager ) ;
			sceneManager.switchScene( new LoginScene() ) ;
			
			//4 初始化消息
			// 发送初始化消息
			var msg:InitInfoMessage = new InitInfoMessage();
			msg.sendTimes = 1 ;
			ContextManager.context.dispatchEvent(msg);
		}
	}
}