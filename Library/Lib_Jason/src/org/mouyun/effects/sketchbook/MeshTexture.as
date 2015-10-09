package org.mouyun.effects.sketchbook
{
    import __AS3__.vec.*;
    import flash.display.*;
    import flash.geom.*;

    public class MeshTexture extends Sprite
    {
        protected var _col:int;
        protected var _points:Array;
        protected var _originalVertices:Vector.<Number>;
        protected var _vertices:Vector.<Number>;
        protected var _row:int;
        protected var _bitmapData:BitmapData;
        protected var _indices:Vector.<int>;
        protected var _uvtData:Vector.<Number>;

        public function MeshTexture(param1:BitmapData, param2:int, param3:int)
        {
			this.mouseEnabled = false;
            this._bitmapData = param1;
            this._col = param2;
            this._row = param3;
            this.reset();
            return;
        }// end function

        public function get col() : Number
        {
            return this._col;
        }// end function

        protected function initIndices() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_1:int = 0;
            while (_loc_1 < (this._row - 1))
            {
                
                _loc_2 = 0;
                while (_loc_2 < (this._col - 1))
                {
                    
                    _loc_3 = _loc_1 * this._col + _loc_2;
                    _loc_4 = _loc_3 + 1;
                    _loc_5 = (_loc_1 + 1) * this._col + _loc_2;
                    _loc_6 = _loc_5 + 1;
                    this._indices.push(_loc_3, _loc_4, _loc_6);
                    this._indices.push(_loc_3, _loc_6, _loc_5);
                    _loc_2++;
                }
                _loc_1++;
            }
            return;
        }// end function

        protected function initUVTData() : void
        {
            var _loc_2:int = 0;
            var _loc_1:int = 0;
            while (_loc_1 < this._row)
            {
                
                _loc_2 = 0;
                while (_loc_2 < this._col)
                {
                    
                    this._uvtData.push(_loc_2 / (this._col - 1), _loc_1 / (this._row - 1));
                    _loc_2++;
                }
                _loc_1++;
            }
            return;
        }// end function

        public function reset() : void
        {
            this._vertices = new Vector.<Number>;
            this._indices = new Vector.<int>;
            this._uvtData = new Vector.<Number>;
            this.initVertices();
            this.initIndices();
            this.initUVTData();
            return;
        }// end function

        public function update() : void
        {
            var _loc_1:* = this.graphics;
            _loc_1.clear();
            _loc_1.beginBitmapFill(this._bitmapData);
            _loc_1.drawTriangles(this._vertices, this._indices, this._uvtData);
            _loc_1.endFill();
            return;
        }// end function

        public function getOriginalPointAtIndex(meshTexture:int) : Point
        {
            return new Point(this._originalVertices[meshTexture * 2], this._originalVertices[meshTexture * 2 + 1]);
        }// end function

        public function get row() : Number
        {
            return this._row;
        }// end function

        public function setPointAt(vector:int, vector2:int, point:Point) : void
        {
            this.setPointAtIndex(vector * this._col + vector2, point);
            return;
        }// end function

        public function getPointAtIndex(meshTexture:int) : Point
        {
            return new Point(this._vertices[meshTexture * 2], this._vertices[meshTexture * 2 + 1]);
        }// end function

        protected function initVertices() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_1:int = 0;
            while (_loc_1 < this._row)
            {
                
                _loc_2 = 0;
                while (_loc_2 < this._col)
                {
                    
                    _loc_3 = _loc_1 * this._col + _loc_2;
                    _loc_4 = _loc_3 + 1;
                    _loc_5 = (_loc_1 + 1) * this._col + _loc_2;
                    _loc_6 = _loc_5 + 1;
                    this._vertices.push(this._bitmapData.width / this._col * _loc_2);
                    this._vertices.push(this._bitmapData.height / this._row * _loc_1);
                    _loc_2++;
                }
                _loc_1++;
            }
            this._originalVertices = this._vertices.concat();
            return;
        }// end function

        public function numPoint() : Number
        {
            return this._col * this._row;
        }// end function

        public function setPosAtIndex(vector:int, vector2:Number, vector3:Number) : void
        {
            this._vertices[vector * 2] = vector2;
            this._vertices[vector * 2 + 1] = vector3;
            return;
        }// end function

        public function setPointAtIndex(vector:int, point:Point) : void
        {
            this._vertices[vector * 2] = point.x;
            this._vertices[vector * 2 + 1] = point.y;
            return;
        }// end function

        public function getPointAt(meshTexture:int, meshTexture2:int) : Point
        {
            return this.getPointAtIndex(meshTexture * this._col + meshTexture2);
        }// end function

    }
}
