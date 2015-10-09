package com.vox.future.sundry
{
	import com.vox.future.utils.MaskUtil;

	public class DefaultSundry implements ISundry
	{
		public function DefaultSundry()
		{
		}
		
		public function addRequestMask($request:*):void
		{
			MaskUtil.addMask( true ) ;
		}
		
		public function removeRequestMask($request:*):void
		{
			MaskUtil.removeMask( true ) ;
		}
	}
}