package com.vox.future.utils
{
	import com.greensock.TweenLite;
	import com.vox.future.managers.ContextManager;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * 功能: 遮罩工具
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class MaskUtil
	{
		private static var _masking:Boolean = false;
		private static var _masker:Sprite;
		
		/** 动画过渡毫秒数 */
		public static var duration:Number = 300;
		/** 黑色透明度 */
		public static var alpha:Number = 0;
		
		/**
		 * 添加一个黑色半透明遮罩
		 * @param tween 是否使用过渡动画
		 * @param alpha 如果规定值，则使用该值，否则使用默认值
		 */		
		public static function addMask(tween:Boolean=false, alpha:Number=-1):void
		{
			if(alpha == -1) alpha = MaskUtil.alpha;
			if(!_masking)
			{
				_masking = true;
				var stage:Stage = ContextManager.context.getObjectByType(Stage);
				if(_masker == null) _masker = new Sprite();
				// 重新绘制，因为stage尺寸有可能会改变
				with(_masker.graphics)
				{
					clear();
					beginFill(0, alpha);
					drawRect(0, 0, stage.stageWidth, stage.stageHeight);
					endFill();
				}
				if(tween)
				{
					_masker.alpha = 0;
					// 添加显示
					stage.addChild(_masker);
					// 动画显示
					TweenLite.killTweensOf(_masker);
					TweenLite.to(_masker, duration * 0.001, {alpha:1});
				}
				else
				{
					// 添加显示
					stage.addChild(_masker);
				}
			}
		}
		
		/** 移除之前添加的遮罩 */
		public static function removeMask(tween:Boolean=false):void
		{
			if(_masking)
			{
				if(tween)
				{
					// 动画显示
					TweenLite.killTweensOf(_masker);
					TweenLite.to(_masker, duration * 0.001, {alpha:0, onComplete:function():void
					{
						if(_masker.parent != null)
						{
							_masker.parent.removeChild(_masker);
						}
					}});
				}
				else
				{
					if(_masker.parent != null)
					{
						_masker.parent.removeChild(_masker);
					}
				}
				_masking = false;
			}
		}
	}
}