package lib
{
	
	public function dump(obj:*):void
	{
		if ("width" in obj)
			trace("  : " + obj.width + ", " + obj.height)
		if ("contentWidth" in obj)
			trace("c : " + obj.contentWidth + ", " + obj.contentHeight);
		if ("measuredWidth" in obj)
			trace("m : " + obj.measuredWidth + ", " + obj.measuredHeight);
		if ("explicitWidth" in obj)
			trace("ex: " + obj.explicitWidth + ", " + obj.explicitHeight);
	}
	
}