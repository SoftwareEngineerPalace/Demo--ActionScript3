package org.mouyun.effects.sketchbook
{
    import flash.display.*;
    import flash.geom.*;

    public class SketchBook extends Object
    {
        private static var _stage:Stage;

        public function SketchBook()
        {
            return;
        }// end function

        public static function switchScreen() : void
        {
            if (isFullScreen())
            {
                normal();
            }
            else
            {
                fullScreen();
            }
            return;
        }// end function

        public static function isLocal() : Boolean
        {
            return stage.loaderInfo.url.indexOf("file:") == 0 ? (true) : (false);
        }// end function

        public static function get centerX() : Number
        {
            return stage.stageWidth * 0.5;
        }// end function

        public static function get centerY() : Number
        {
            return stage.stageHeight * 0.5;
        }// end function

        public static function get stage() : Stage
        {
            if (_stage == null)
            {
                throw new Error("SketchBook is not initialized yet. call SketchBook.init() first.");
            }
            return _stage;
        }// end function

        public static function isFullScreen() : Boolean
        {
            return stage.displayState == StageDisplayState.FULL_SCREEN ? (true) : (false);
        }// end function

        public static function get stageWidth() : Number
        {
            return stage.stageWidth;
        }// end function

        public static function noScale() : void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            return;
        }// end function

        public static function mediumQuality() : void
        {
            stage.quality = StageQuality.MEDIUM;
            return;
        }// end function

        public static function lowQuality() : void
        {
            stage.quality = StageQuality.LOW;
            return;
        }// end function

        public static function get stageHeight() : Number
        {
            return stage.stageHeight;
        }// end function

        public static function get frameRate() : uint
        {
            return stage.frameRate;
        }// end function

        public static function normal() : void
        {
            stage.displayState = StageDisplayState.NORMAL;
            return;
        }// end function

        public static function init(param1:Stage) : void
        {
            SketchBook._stage = param1;
            return;
        }// end function

        public static function get stageRect() : Rectangle
        {
            return new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        }// end function

        public static function get mouseX() : Number
        {
            return stage.mouseX;
        }// end function

        public static function get mouseY() : Number
        {
            return stage.mouseY;
        }// end function

        public static function get flashVars() : Object
        {
            return LoaderInfo(stage.root.loaderInfo).parameters;
        }// end function

        public static function set frameRate(param1:uint) : void
        {
            stage.frameRate = frameRate;
            return;
        }// end function

        public static function fullScreen() : void
        {
            stage.displayState = StageDisplayState.FULL_SCREEN;
            return;
        }// end function

        public static function topLeft() : void
        {
            stage.align = StageAlign.TOP_LEFT;
            return;
        }// end function

        public static function highQuality() : void
        {
            stage.quality = StageQuality.HIGH;
            return;
        }// end function

    }
}
