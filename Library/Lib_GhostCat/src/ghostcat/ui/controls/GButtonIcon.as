/**
 *
 *@author <a href="mailto:daming.wang@happyelements.com">daming.wang</a>
 *@version $Id$
 *
 **/

package ghostcat.ui.controls
{
	import flash.display.MovieClip;

	import ghostcat.display.movieclip.GMovieClip;

	public class GButtonIcon extends GButtonLite
	{
		public var icon:GMovieClip

		public function GButtonIcon(skin:*=null, replace:Boolean=true, replaceSkin:*=null)
		{
			super(skin, replace, replaceSkin);
		}

		protected override function createMovieClip():void
		{
			if (movie)
				movie.destory();

			movie=new GMovieClip(content, false, !enabledLabelMovie);

			if ((content is MovieClip && (content as MovieClip).totalFrames > 1) && !(movie.labels && movie.labels.length))
			{
				if ((content as MovieClip).totalFrames == 3)
					movie.labels=GButtonBase.defaultLabels_3frame;
				else
					movie.labels=GButtonBase.defaultLabels;
			}

			if (icon)
				icon.destory();
			if (content['icon'])
			{
				icon=new GMovieClip(content['icon'], false, true);
			}
		}

		override public function get data():*
		{
			// TODO Auto Generated method stub
			return super.data;
		}

		override public function set data(v:*):void
		{
			// TODO Auto Generated method stub
			super.data=v;
			if (icon)
			{
				icon.currentFrame=v;
			}
		}

	}
}
