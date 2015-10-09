package
{
	import com.vox.test.utils.Scale9GridSpr;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	[SWF(width="900", height="600", frameRate="24", backgroundColor ="0")]
	public class Test9Scale extends Sprite
	{
		public function Test9Scale()
		{
			//加上挡板
			var bmb:Bitmap = new Bitmap( new Plate() ) ;
			var plate:Scale9GridSpr= new Scale9GridSpr( bmb, new Rectangle( 105,53,184,141) ) ;
			addChild( plate ) ;
			plate.width = 900 ;
		}
	}
}