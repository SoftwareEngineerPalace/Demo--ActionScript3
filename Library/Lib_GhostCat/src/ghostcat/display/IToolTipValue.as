package ghostcat.display
{
	/**
	 * 使用该接口的Tip数据相当于与某个ToolTipSkin做了绑定，所以可以不用再手动设置toolTipObj属性
	 * 
	 * @author Raykid
	 * 
	 */
	public interface IToolTipValue
	{
		/** 获取绑定的ToolTip显示对象 */
		function getToolTipObj():*;
	}
}