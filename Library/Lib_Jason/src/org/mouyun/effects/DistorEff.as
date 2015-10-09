package org.mouyun.effects
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.net.*;
    import org.libspark.betweenas3.*;
    import org.libspark.betweenas3.core.easing.*;
    import org.libspark.betweenas3.tweens.*;
    import org.mouyun.effects.sketchbook.*;

    public class DistorEff extends Sprite
    {
		//instance
		private static var _instance:DistorEff;
        private var _isTween:Boolean;
        private var _meshTx:MeshTexture;
        private var _ge:GinnyEffect;
		private var _bitmapdata:BitmapData;
		private var _stage:Stage;
		private var _name:String;
		private var _frameRate:Number;
		private var _exeRate:Number;
		private var _correct:Number;
		private var _flexibility:int;
		
        public function DistorEff(privateClass:PrivateClass)
        {
			if (!privateClass) {
				throw Error("亲~!不能实例化喔.你可能需要getInstance()");
				return;
			}
        }
		
		public function startInit($stage:Stage):void
		{
			SketchBook.init($stage);
            SketchBook.noScale();
            SketchBook.topLeft();
            //SketchBook.lowQuality();
			_exeRate = 60;
			_correct = 1.11;
			_flexibility = 10;
            _isTween = false;
			_stage = $stage;
			_frameRate = $stage.frameRate;
			_bitmapdata = new BitmapData(_stage.stageWidth, _stage.stageHeight, true, 0x00FFFFFF);
			run(_bitmapdata, _flexibility);
		}
		
		/**
		 * 返回单例
		 */
		public static function getInstance():DistorEff {
			if (!_instance) _instance = new DistorEff(new PrivateClass());
			return _instance;
		}
		
		/**
		 * 执行失真特效特效
		 * @param	child 特效对象
		 * @param	layer 特效的父级对象
		 * @param	startPoint 特效起始的坐标
		 * @param	endPoint 特效结束的坐标
		 * @param	time 执行特效的时间
		 * @param	completeHandler 特效执行完成的回调函数回调函数
		 */
		public static function execute(child:DisplayObject, layer:Sprite, startPoint:Point , endPoint:Point, time:Number = 0.5, completeHandler:Function = null):void
		{
			if (_instance._isTween) return;
			if (!_instance) _instance = new DistorEff(new PrivateClass());
			_instance._isTween = true;
			_instance._stage.frameRate = _instance._exeRate;
			//_instance._stage.quality = StageQuality.LOW;
			
			//显示数据处理
			if(_instance._name != child.name)
			{
				//赋值阶段
				_instance._name = child.name;
				//缓存阶段
				_instance._bitmapdata.lock();
				_instance._bitmapdata.fillRect(new Rectangle(0, 0, _instance._stage.stageWidth, _instance._stage.stageHeight), 0x00FFFFFF);
				if (child is Bitmap)
				{
					_instance._bitmapdata.copyPixels((child as Bitmap).bitmapData, new Rectangle(0, 0, child.width, child.height), new Point(0, 0));
					_instance._meshTx.scaleX = _instance._meshTx.scaleY = _instance._correct;
				}else{
					_instance._bitmapdata.draw(child, new Matrix(_instance._correct, 0, 0, _instance._correct));
					_instance._meshTx.scaleX = _instance._meshTx.scaleY = 1;
				}
				_instance._bitmapdata.unlock();
			}
			
			//display
			layer.addChild(_instance._meshTx);
			layer.addChild(child);
			
			//定位
			child.x = _instance._meshTx.x = endPoint.x;
			child.y = _instance._meshTx.y = endPoint.y;
			
			//visible
			child.visible = false;
			
			//执行特效
			var objectTween:IObjectTween = null;
			_instance._ge.progress = 0;
			_instance._ge.vanishingPoint = _instance._meshTx.globalToLocal(startPoint);
			
			_instance._ge.progress = 1;
			objectTween = BetweenAS3.tween(_instance._ge, { progress:0 }, null, time);
			objectTween.onComplete = tweenComplete;
			objectTween.play();
			
			function tweenComplete():void
			{
				//_instance._stage.quality = StageQuality.HIGH;
				_instance._stage.frameRate = _instance._frameRate;
				_instance._isTween = false;
				layer.removeChild(_instance._meshTx);
				//_instance._bitmapdata.dispose();
				child.visible = true;
				if (completeHandler != null) completeHandler();
			}
		}
		
		/**
		 * 执行还原特效
		 * @param	child 特效对象
		 * @param	layer 特效的父级对象
		 * @param	startPoint 特效起始的坐标
		 * @param	endPoint 特效结束的坐标
		 * @param	time 执行特效的时间
		 * @param	completeHandler 特效执行完成的回调函数回调函数
		 */
		public static function undo(child:DisplayObject, layer:Sprite, startPoint:Point , endPoint:Point, time:Number = 0.5, completeHandler:Function = null):void
		{
			if (_instance._isTween) return;
			if (!_instance) _instance = new DistorEff(new PrivateClass());
			_instance._isTween = true;
			_instance._stage.frameRate = _instance._exeRate;
			//_instance._stage.quality = StageQuality.LOW;
			
			//显示数据处理
			if(_instance._name != child.name)
			{
				//赋值阶段
				_instance._name = child.name;
				//缓存阶段
				_instance._bitmapdata.lock();
				_instance._bitmapdata.fillRect(new Rectangle(0, 0, _instance._stage.stageWidth, _instance._stage.stageHeight), 0x00FFFFFF);
				if (child is Bitmap)
				{
					_instance._bitmapdata.copyPixels((child as Bitmap).bitmapData, new Rectangle(0, 0, child.width, child.height), new Point(0, 0));
					_instance._meshTx.scaleX = _instance._meshTx.scaleY = _instance._correct;
				}else{
					_instance._bitmapdata.draw(child, new Matrix(_instance._correct, 0, 0, _instance._correct));
					_instance._meshTx.scaleX = _instance._meshTx.scaleY = 1;
				}
				_instance._bitmapdata.unlock();
			}
			
			//display
			layer.addChild(_instance._meshTx);
			layer.addChild(child);
			
			//定位
			child.x = _instance._meshTx.x = startPoint.x;
			child.y = _instance._meshTx.y = startPoint.y;
			
			//visible
			child.visible = false;
			
			//执行特效
            var objectTween:IObjectTween = null;
			_instance._ge.progress = 0
			_instance._ge.vanishingPoint = _instance._meshTx.globalToLocal(endPoint);
			objectTween = BetweenAS3.tween(_instance._ge, {progress:1}, null, time);
			objectTween.onComplete = tweenComplete;
			objectTween.play();
			
			function tweenComplete():void
			{
				//_instance._stage.quality = StageQuality.HIGH;
				_instance._stage.frameRate = _instance._frameRate;
				_instance._isTween = false;
				layer.removeChild(_instance._meshTx);
				layer.removeChild(child);
				//_instance._bitmapdata.dispose();
				if (completeHandler != null) completeHandler();
			}
		}
		
        private function run(bitmapdata:BitmapData, flexibility:int):void
        {
            _meshTx = new MeshTexture(bitmapdata, flexibility, flexibility);
            _meshTx.update();
            //addChild(_meshTx);
			_ge = new GinnyEffect(_meshTx);
			_ge.xEasingFunction = new QuadraticEaseIn().calculate;
			_ge.yEasingFunction = new QuinticEaseIn().calculate;
			_ge.xEasingFunction = new QuadraticEaseIn().calculate;
			_ge.yEasingFunction = new ExponentialEaseIn().calculate;
        }
		
        /*private function updatePosition():void
        {
            _meshTx.x = 0;
            _meshTx.y = 0;
        }*/
		
		public function get isTween():Boolean 
		{
			return _isTween;
		}
    }
}
class PrivateClass {}