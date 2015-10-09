/**
 *
 *@author <a href="mailto:jacob.zhang@happyelements.com">Jacob zhang</a>
 *@version $Id: ZoomInEffect.as 332410 2013-05-22 11:07:16Z jacob.zhang $
 *
 **/
package ghostcat.operation.effect
{
    import flash.geom.Point;

    import ghostcat.operation.TweenOper;
    import ghostcat.util.display.Geom;

    public class ZoomInEffect extends TweenOper
    {
        /**
         * 中心点（父节点坐标系）
         */
        public var center:Point;

        /**
         * 缩放比
         */
        public var scale:Number;

        public function ZoomInEffect(target:* = null,center:Point = null,scale:Number = 1.0,duration:int = 100,params:Object = null,invert:Boolean = false,clearTarget:* = 0)
        {
            this.center = center;
            this.scale = scale;
            super(target,duration,params,invert,clearTarget);
        }

        /** @inheritDoc*/
        public override function execute():void
        {
            if (!params)
                params = new Object();

            if (!center)
                center = Geom.center(target);

            params.scaleX = params.scaleY = this.scale;
            params.x = target.x + (target.x - center.x) * (scale - target.scaleX) / target.scaleX;
            params.y = target.y + (target.y - center.y) * (scale - target.scaleY) / target.scaleY;
            params.alpha = 1;
            super.execute();
        }
    }
}