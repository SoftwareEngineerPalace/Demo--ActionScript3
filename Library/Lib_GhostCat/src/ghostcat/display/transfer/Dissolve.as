/**
 *溶解
 *@author <a href="mailto:jacob.zhang@happyelements.com">Jacob zhang</a>
 *@version $Id: Dissolve.as 325931 2013-04-30 01:44:31Z jacob.zhang $
 *
 **/
package ghostcat.display.transfer
{
    import flash.display.DisplayObject;
    import flash.geom.Point;

    public class Dissolve extends GBitmapEffect
    {
        /**
         * 随机因子
         */
        public var randSeed:int;

        public function Dissolve(target:DisplayObject = null,randSeed:int = 0)
        {
            super(target);
            if (randSeed == 0)
                randSeed = new Date().getTime();
            this.randSeed = randSeed;

        }

        public override function start():void
        {
            renderTarget();
//            bitmapData.copyPixels(normalBitmapData,normalBitmapData.rect,new Point());

            bitmapData.fillRect(bitmapData.rect,0);
            bitmapData.pixelDissolve(normalBitmapData,normalBitmapData.rect,new Point(),randSeed,(1 - deep) * bitmapData.width * bitmapData.height);

            super.start();
        }
    }
}