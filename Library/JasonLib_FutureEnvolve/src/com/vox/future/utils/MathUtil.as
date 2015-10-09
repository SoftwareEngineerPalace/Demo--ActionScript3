package com.vox.future.utils
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import fmath.ConvertFromLatexToMathML;
	import fmath.MathML;
	import fmath.Style;

	/**
	 * 功能: 数学工具，主要用于处理Latex字符串显示的
	 * <br>
	 * 版权: ©Raykid
	 * <br>
	 * 作者: Raykid
	 */
	public class MathUtil
	{
		/**
		 * 通过一个TextField创建一个用于Latex的Style对象
		 * @param textField 样式模板TextField
		 * @return 创建出来的Style对象
		 */		
		public static function createLatexStyleByTextField(textField:TextField):Style
		{
			var format:TextFormat = textField.defaultTextFormat;
			var style:MathStyle = new MathStyle();
			if(textField.background)
			{
				style.bgcolor = "#" + textField.backgroundColor.toString(16);
			}
			if(textField.border)
			{
				style.border = 1;
				style.bordercolor = "#" + textField.borderColor.toString(16);
			}
			style.color = "#" + uint(format.color).toString(16);
			style.size = Number(format.size);
			style.mathvariant = "normal";
			style.fontstyle = "normal";
			style.setBold(true);
			style.setFamilyName(Capabilities.os.substr(0, 3) == "mac" ? "STSong" : "SimSun");
			// 以下是自定义属性
			style.align = format.align;
			style.filters = textField.filters;
			style.textX = textField.x;
			style.textY = textField.y;
			style.textWidth = textField.width;
			style.textHeight = textField.height;
			return style;
		}
		
		/**
		 * 在一个已有的Sprite上绘制Latex字符串
		 * @param sprite 在其上绘制的Sprite
		 * @param latexStr Latex字符串
		 * @param style Latex样式
		 * @param callback 更新并布局完毕后的回调
		 */		
		public static function drawLatexSprite(sprite:Sprite, latexStr:String, style:Style, callback:Function=null):void
		{
			var xmlData:XML = new XML(ConvertFromLatexToMathML.convertToMathML(latexStr));
			var mathML:MathML = new MathML(xmlData, style);
			mathML.drawFormula(sprite, function(r:Rectangle):void
			{
				var mathStyle:MathStyle = style as MathStyle;
				if(mathStyle != null)
				{
					sprite.filters = mathStyle.filters;
					switch(mathStyle.align)
					{
						case "center":
							sprite.x = mathStyle.textX + mathStyle.textWidth * 0.5 - r.width * 0.5 - r.x;
							break;
						case "right":
							sprite.x = mathStyle.textX + mathStyle.textWidth - r.width - r.x;
							break;
						default:
							break;
					}
					sprite.y = mathStyle.textY + mathStyle.textHeight * 0.5 - r.height * 0.5 - r.y;
					if(callback != null) callback(r);
				}
			});
		}
		
		/**
		 * 创建一个Latex Sprite
		 * @param latexStr Latex字符串
		 * @param style Latex样式
		 * @param callback 更新并布局完毕后的回调
		 * @return Latex Sprite
		 */		
		public static function createLatexSprite(latexStr:String, style:Style, callback:Function=null):Sprite
		{
			var sprite:Sprite = new Sprite();
			drawLatexSprite(sprite, latexStr, style, callback);
			return sprite;
		}
	}
}


import flash.geom.Rectangle;

import fmath.Style;

class MathStyle extends Style
{
	public var align:String;
	public var filters:Array;
	public var textX:Number;
	public var textY:Number;
	public var textWidth:Number;
	public var textHeight:Number;
	
	public function MathStyle()
	{
		super();
	}
}