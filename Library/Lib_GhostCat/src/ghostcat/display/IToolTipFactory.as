/**
 *
 *@author <a href="mailto:jacob.zhang@happyelements.com">Jacob zhang</a>
 *@version $Id: IToolTipFactory.as 337514 2013-06-06 08:05:06Z rui.liu $
 *
 **/
package ghostcat.display
{
	public interface IToolTipFactory
	{
		/**
		 * 该工厂需要支持类型映射
		 * @param toolTip tip数据
		 * @return tip数据对应的tip
		 */		
		function getToolTipObj(toolTip:*):*;
	}
}