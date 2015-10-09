package ghostcat.util.text
{
	public final class TextTransferUtil
	{
		static public function XMLEncode(str:String):String
		{
			var xml:XML = <xml/>
			xml.appendChild(str);
			var v:String = xml.toXMLString();
			v = v.replace(/\r/gi,"&#xd;");
			v = v.replace(/\n/gi,"&#xa;");
			return v.slice(5,v.length - 6);
		}
		
		static public function XMLDecode(str:String):String
		{
			try
			{
				var xml:XML =  new XML("<xml>" + str + "</xml>")
				return xml.toString();
			}catch (e:Error){};
			return null;
		}
		
		static public function stringEncode(str:String):String
		{
			return str.replace(/\"|\\/g,"\\$&");
		}
		
		static public function stringDecode(str:String):String
		{
			return str.replace(/\\(.)/g,"$1");
		}
	}
}