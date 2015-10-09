/**
 *
 *@author <a href="mailto:wukui.peng@happyelements.com">Wukui.Peng</a>
 *@version $Id: GPercentBarEx.as 388360 2013-10-25 03:02:53Z wukui.peng $
 *
 **/
package ghostcat.ui.controls
{


    public class GPercentBarEx extends GPercentBar
    {
        private var _realMap:Array;

        private var _scaleMap:Array;

        private var _showMap:Array;

        public function GPercentBarEx(skin:* = null,replace:Boolean = true,mode:String = "scaleX",fields:Object = null)
        {
            super(skin,replace,mode,fields);
        }

        /**
         * 自定义比例条
         * 示例[0.2,0.35,0.3,0.4,0.6,0.6...........]
         * 偶数位为要显示的实际比例，奇数位为数值的实际比例
         */
        public function set scaleMap(value:Array):void
        {
            _scaleMap = value;
            _realMap = [0.0];
            _showMap = [0.0];

            for (var i:int = 0;i < value.length;i++)
            {
                if (i % 2 == 1)
                {
                    _realMap.push(value[i]);
                }
                else
                {
                    _showMap.push(value[i]);
                }
            }
            _realMap.push(1.0);
            _showMap.push(1.0);
        }

        override public function setPercent(v:Number,tween:Boolean = true):void
        {

            var showValue:Number = 0.0;
            if (_scaleMap == null)
            {
				
            }
            else
            {
                try
                {
					if(v <0)
					{
						showValue = 0;
					}
					else if(v > 1)
					{
						showValue = 1;
					}
					else
					{
						var realValue:Number = v;
						
						for (var i:int = 0;i < _realMap.length;i++)
						{
							if (realValue >= _realMap[i] && realValue <= _realMap[i + 1])
							{
								showValue = _showMap[i] + (_showMap[i + 1] - _showMap[i]) * ((realValue - _realMap[i]) / (_realMap[i + 1] - _realMap[i]));
								break;
							}
						}
					}
                    
                }
                catch (error:Error)
                {
                    trace("PProgressBar设置了错误的scaleMap!");
                    showValue = v;
                }
            }

            super.setPercent(showValue,tween);

        }
    }
}

