package com.vox.future.vos
{
	/**
	 * 根据弱类型参数自动赋值
	 * @author jishu
	 */
	public class DefaultVO
	{
		public function DefaultVO( $value:Object )
		{
			for ( var key:String in $value ) 
			{
				if( this.hasOwnProperty( key ) )
				{
					this[ key ] = $value[ key ]
				}
			}
			
		}
	}
}