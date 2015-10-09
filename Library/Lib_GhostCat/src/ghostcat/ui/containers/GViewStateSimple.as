package ghostcat.ui.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import ghostcat.display.GBase;
	import ghostcat.display.movieclip.GMovieClip;
	import ghostcat.events.MovieEvent;
	
	/**
	 * GViewState简化版
	 * 不显示的对象从舞台移除
	 * child必须为MovieClip，以其name属性作为状态名，显示的时候根据状态名取对象
	 * 
	 * 修改自GViewState
	 * @author Helcarin
	 */
	public class GViewStateSimple extends GBase
	{
		protected var _childrenMap:Object = {};
		protected var _currentChild:GMovieClip;
		
		public function GViewStateSimple(skin:* = null, replace:Boolean = true)
		{
			super(skin, replace);
			
			var container:DisplayObjectContainer = content as DisplayObjectContainer;
			for(var i:int=container.numChildren-1; i>=0; i--)
			{
				var child:MovieClip = container.getChildAt(i) as MovieClip;
				if (!child) continue;
				
				var gchild:GMovieClip = new GMovieClip(child);
				_childrenMap[child.name] = gchild;
				gchild.addEventListener(MovieEvent.MOVIE_EMPTY, movieEmptyHandler);
				
				container.removeChildAt(i);
			}
			
			_currentChild = null;
		}
		
		/**
		 * 显示一个子对象
		 * @param $state  	状态名（子对象的name）
		 * @param $repeat 	重复播放次数
		 */
		public function setState($state:String, $repeat:int=-1):void
		{
			var child:GMovieClip = _childrenMap[$state];
			
			if (_currentChild)
			{
				if (_currentChild.parent) _currentChild.parent.removeChild(_currentChild);
			}
			
			if (child)
			{
				(content as DisplayObjectContainer).addChild(child);
				child.setLabel(null, $repeat);
			}
			
			_currentChild = child;
		}
		
		private function movieEmptyHandler($event:MovieEvent):void
		{
			if ($event.currentTarget == _currentChild)
			{
				this.dispatchEvent($event);
			}
		}
		
		/****** getter ******/
		
		/**
		 * 获取当前显示的子对象
		 */
		public function get currentChild():DisplayObject
		{
			return _currentChild;
		}
	}
}