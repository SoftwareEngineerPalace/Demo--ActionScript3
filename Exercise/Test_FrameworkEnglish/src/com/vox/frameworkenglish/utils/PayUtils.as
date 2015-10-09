package com.vox.frameworkenglish.utils
{
	import com.vox.frameworkenglish.vos.IItemVO;
	
	import ghostcat.ui.containers.GAlert;

	/**
	 * 支付工具类 
	 * @author jishu
	 * 
	 */
	public class PayUtils
	{
		public function PayUtils()
		{
		}
		
		public static function  buyItme( $value:IItemVO, $onSuccessCbk:Function=null, $onFailCbk:Function=null, $onCancelCbk=null):void
		{
			var alert:GAlert ;//总结
			
		}
	}
}