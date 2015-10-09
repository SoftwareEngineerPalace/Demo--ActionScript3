package ghostcat.game.item
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import ghostcat.events.MovieEvent;
    import ghostcat.events.TickEvent;
    import ghostcat.game.util.GameTick;

    [Event(name="label_end",type="ghostcat.events.MovieEvent")]
    /**
     * 动画对象
     * @author flashyiyi
     *
     */
    public class BitmapMovieGameItem extends BitmapGameItem
    {
        public var bitmapDatas:Vector.<BitmapData>;
        public var bitmapOffests:Vector.<Point>;
        public var frameRate:Number;

        private var _enabledTick:Boolean;
        private var _currentFrame:int;
        public var frameTimer:int;
        public var loops:int = -1;

        public function BitmapMovieGameItem(bitmapDatas:Vector.<BitmapData>,frameRate:Number)
        {
            super(null);

            this.bitmapDatas = bitmapDatas;
            this.frameRate = frameRate;
            this.currentFrame = 0;

            this.enabledTick = true;
        }

        /**
         * 随机设置时间初值，可以错开图片更新时机增加性能
         *
         */
        public function randomFrameTimer():void
        {
            this.frameTimer += Math.random() * 1000 / frameRate;
        }

        public function resetFrameTimer():void
        {
            this.frameTimer = 0;
        }

        public function get currentFrame():int
        {
            return _currentFrame;
        }

        public function set currentFrame(value:int):void
        {
            if (!bitmapDatas)
                return;

            var totalFrame:int = bitmapDatas.length;
            if (value >= totalFrame)
                value = totalFrame - 1;

            _currentFrame = value;
            if (bitmapData == bitmapDatas[value])
                return;

            bitmapData = bitmapDatas[value];

            if (bitmapOffests && bitmapOffests.length)
            {
                var offest:Point = bitmapOffests[value];
                this.offestX = offest.x;
                this.offestY = offest.y;

                this.applyRegPosition();
            }
        }

        public function get totalFrame():int
        {
            return bitmapDatas ? bitmapDatas.length : 0;
        }

        /** @inheritDoc */
        public function get enabledTick():Boolean
        {
            return _enabledTick;
        }

        public function set enabledTick(v:Boolean):void
        {
            if (_enabledTick == v)
                return;

            _enabledTick = v;

            if (_enabledTick)
                GameTick.instance.addEventListener(TickEvent.TICK,tickHandler);
            else
                GameTick.instance.removeEventListener(TickEvent.TICK,tickHandler);
        }

        protected function tickHandler(event:TickEvent):void
        {
            tick(event.interval);
        }

        public function tick(t:int):void
        {
            if (!bitmapDatas || loops == 0)
                return;

            frameTimer -= t;
            while (frameTimer < 0)
            {
                if (currentFrame >= bitmapDatas.length - 1)
                {
                    if (loops > 0)
                        loops--;

                    if (loops == 0)
                    {
                        this.frameTimer = 0;
                        this.dispatchEvent(new MovieEvent(MovieEvent.MOVIE_END))
                        return;
                    }
                    else
                    {
                        this.currentFrame = 0;
                    }
                }
                else
                {
                    currentFrame++;
                }

                frameTimer += 1000 / frameRate;
            }
        }

        public function destory():void
        {
            this.enabledTick = false;
        }

    }
}