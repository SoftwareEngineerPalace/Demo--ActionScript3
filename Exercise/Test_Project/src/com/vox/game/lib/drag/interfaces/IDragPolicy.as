package com.vox.game.lib.drag.interfaces
{
	public interface IDragPolicy
	{
		/**
		 * 布局宽度
		 * @return 
		 */
		function get layoutWidth():Number ;
		/**
		 * 水平间距
		 * @return 
		 */
		function get horizantalGap():Number ;
		/**
		 * 行高
		 * @return 
		 */
		function get rowHeigth():Number ;
		
		/**
		 * 生成单词实体
		 * @param $word
		 * @return 
		 */
		function createWordEntity( $word:String )
			
	}
}