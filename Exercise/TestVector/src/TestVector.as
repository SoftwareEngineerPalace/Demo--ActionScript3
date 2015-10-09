package
{
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class TestVector extends Sprite
	{
		public function TestVector()
		{
			test1();
		}
		
		private function getVectorClass(contentClass:Class):Class
		{
			var contentName:String = getQualifiedClassName(contentClass);
			var vectorName:String = "__AS3__.vec::Vector.<" + contentName + ">";
			var vectorClass:Class = getDefinitionByName(vectorName) as Class;
			
			return vectorClass;
		}
		
		private function describe(v:*):void
		{
			trace("-----------------------------");
			trace("class name: " + getQualifiedClassName(v));
			trace("is .<*>: " + (v is Vector.<*>));
			trace("describe: \n" + describeType(v)); 
		}
		
		private function test1():void
		{
			describe(new (getVectorClass(Number)));
			describe(new (getVectorClass(uint)));
			describe(new (getVectorClass(int)));
			describe(new Vector.<*>);
			describe(new (getVectorClass(String)));
		}		
		
		
		
	}
}