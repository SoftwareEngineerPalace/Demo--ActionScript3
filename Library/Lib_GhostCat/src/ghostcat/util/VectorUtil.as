package ghostcat.util
{

	public final class VectorUtil
	{
		/*static public function vectorToArray(vector:Vector,array:Array):void
		{
			var l:int = vector.length;
			array.length = 0;
			for (var i:int = 0;i < l;i++)
				array[i] = vector[i];
		}*/

		static public function vectorToArray(vector:*):Array
		{
			var array:Array = new Array();
			var callback:Function = function(item:*,index:int,vector:*):Boolean
			{
				array.push(item);
				return true;
			}
			vector.every(callback);
			return array;
		}

		static public function arrayToVector(array:Array,vector:*):void
		{
			vector.length = 0;
			vector.push.apply(null,array);
		}
	}
}