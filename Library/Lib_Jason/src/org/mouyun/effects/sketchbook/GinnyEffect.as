package org.mouyun.effects.sketchbook
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;

    public class GinnyEffect extends Sprite
    {
        protected var _startLastPointTweenProgress:Number;
        public var yEasingFunction:Function;
        protected var maxDistPoint:Point;
        protected var _progress:Number;
        protected var minDistPoint:Point;
        protected var _startProgresses:Vector.<Number>;
        protected var minDist:Number;
        protected var _vanishingPoint:Point;
        protected var maxDist:Number;
        protected var _meshTexture:MeshTexture;
        public var xEasingFunction:Function;
        public var endFirstPointTweenProgress:Number;
		public static var _tempPt:Point = new Point();
		
        public function GinnyEffect(param1:MeshTexture)
        {
            this._progress = 0;
            this._meshTexture = param1;
            this.xEasingFunction = this.easeNone;
            this.yEasingFunction = this.easeNone;
            this.endFirstPointTweenProgress = 0.5;
            this._startLastPointTweenProgress = 1 - this.endFirstPointTweenProgress;
            this.vanishingPoint = new Point(0, 0);
            return;
        }// end function

        public function easeNone(_startLastPointTweenProgress:Number, _startLastPointTweenProgress1:Number, _startLastPointTweenProgress2:Number, _startLastPointTweenProgress3:Number) : Number
        {
            return _startLastPointTweenProgress * _startLastPointTweenProgress1 / _startLastPointTweenProgress2 + _startLastPointTweenProgress3;
        }// end function

        public function set vanishingPoint(minDist:Point) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            var _loc_4:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            trace("vanishing point");
            this._vanishingPoint = minDist;
            this.minDist = Number.POSITIVE_INFINITY;
            this.maxDist = Number.NEGATIVE_INFINITY;
            var _loc_5:* = this._meshTexture.numPoint();
            var _loc_6:int = 0;
            while (_loc_6 < _loc_5)
            {
                
                minDist = this._meshTexture.getOriginalPointAtIndex(_loc_6);
                _loc_2 = this._vanishingPoint.x - minDist.x;
                _loc_3 = this._vanishingPoint.y - minDist.y;
                _loc_4 = Math.sqrt(_loc_2 * _loc_2 + _loc_3 * _loc_3);
                if (_loc_4 < this.minDist)
                {
                    this.minDist = _loc_4;
                    this.minDistPoint = minDist;
                }
                if (_loc_4 > this.maxDist)
                {
                    this.maxDist = _loc_4;
                    this.maxDistPoint = minDist;
                }
                _loc_6++;
            }
            this._startProgresses = new Vector.<Number>;
            _loc_6 = 0;
            while (_loc_6 < _loc_5)
            {
                
                minDist = this._meshTexture.getOriginalPointAtIndex(_loc_6);
                _loc_2 = this._vanishingPoint.x - minDist.x;
                _loc_3 = this._vanishingPoint.y - minDist.y;
                _loc_4 = Math.sqrt(_loc_2 * _loc_2 + _loc_3 * _loc_3);
                _loc_7 = (_loc_4 - this.minDist) / (this.maxDist - this.minDist);
                _loc_8 = this._startLastPointTweenProgress * _loc_7;
                this._startProgresses.push(_loc_8);
                _loc_6++;
            }
            return;
        }// end function

        public function set progress(minDist:Number) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:Point = null;
            var _loc_5:Number = NaN;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (minDist != this._progress)
            {
                this._progress = minDist;
                _loc_2 = this._meshTexture.numPoint();
                _loc_3 = 0;
                while (_loc_3 < _loc_2)
                {
                    
                    _loc_4 = this._meshTexture.getOriginalPointAtIndex(_loc_3);
                    _loc_5 = this._startProgresses[_loc_3];
                    _loc_6 = (this._progress - _loc_5) / this._startLastPointTweenProgress;
                    if (_loc_6 < 0)
                    {
                        _loc_6 = 0;
                    }
                    if (_loc_6 > 1)
                    {
                        _loc_6 = 1;
                    }
                    _loc_7 = this.xEasingFunction(_loc_6, _loc_4.x, this._vanishingPoint.x - _loc_4.x, 1);
                    _loc_8 = this.yEasingFunction(_loc_6, _loc_4.y, this._vanishingPoint.y - _loc_4.y, 1);
                    this._meshTexture.setPosAtIndex(_loc_3, _loc_7, _loc_8);
                    _loc_3++;
                }
                this._meshTexture.update();
            }
            return;
        }// end function

        public function get progress() : Number
        {
            return this._progress;
        }// end function

    }
}
