package
{
	import com.vox.future.Application;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	[SWF(width="900",height="600",frameRate="30",backgroundColor="0xffffff")]
	/**
	 * 动漫主题英语应用框架
	 * @author jishu
	 */
	public class FrameworkEnglish extends Application
	{
		public function FrameworkEnglish()
		{
			
		}
		
		override public function get testFlashVars():Object
		{
			return {
				nextHomeWork:'parent.nextHomeWork',
				imgDomain:'http://cdn-dynamic.test.17zuoye.net/',
				saveVoice:0,
				voicePassScore:30,
				promptDir:'http://cdn-dynamic.test.17zuoye.net/',
				speechScoreUrl:'rtmp://vas.17zuoye.com:443/v2.0/aistream',
				gameDataURL:'http://www.test.17zuoye.net/appdata/flash/Phantom/obtain-ENGLISH-8790001.api?v=1411974255864&ktwelve=PRIMARY_SCHOOL',
				userType:3,
				speechUrlListServiceUrl:'http://www.17zuoye.com/public/aispeech/urllist.json?v=1',
				json:'{"practiceType":112,"lessonId":8790001,"gameType":112,"studyType":"selfstudy","userId":30013,"bookId":878,"unitId":879}',
				voiceEngineType:'internal',
				speechLatencyDetector:':80/v2.0/latencydetect',
				lessonId:8790001,
				flashLogicUrl:'http://cdn-static.test.17zuoye.net/resources/apps/flash/future/logics/ListenSoundChoiceLogic-V20140929145456.swf',
				gameExtraDataURL:'http://www.test.17zuoye.net/',
				endPath:'http://www.test.17zuoye.net/flash/Phantom/process.api?postType=json',
				flashURL:'http://cdn-static.test.17zuoye.net/resources/apps/flash/FrameworkEnglish-V20140929145456.swf',
				domain:'http://www.test.17zuoye.net/',
				flashUrl:'http://cdn-static.test.17zuoye.net/resources/apps/flash/FrameworkEnglish-V20140929145456.swf',
				studyType:'selfstudy',
				appUrl:'http://cdn-static.test.17zuoye.net/resources/apps/flash/Phantom-V20140929012401.swf',
				sendRankDataUrl:'http://www.test.17zuoye.net//interactive/flash/ENGLISH/process.api',
				resVersion:1.0,
				type:112,
				flashGameCoreUrl:'http://cdn-static.test.17zuoye.net/resources/apps/flash/future/game-V20140929145456.swf',
				appId:'Phantom',
				flashId:'FrameworkEnglish',
				netWorkUrl:'http://www.test.17zuoye.net/',
				speechEnabled:true,
				getRankDataUrl:'http://www.test.17zuoye.net//interactive/flash/ENGLISH/getrank.api',
				studyCompleted:'parent.refreshHomeWorkState'
			};
		}
		
		override protected function get version():String
		{
			return CONFIG::VERSION;
		}
		
		override public function listMediatorDict():Dictionary
		{
			// TODO Auto Generated method stub
			return super.listMediatorDict();
		}
		
		
		
		
		
		
	}
}