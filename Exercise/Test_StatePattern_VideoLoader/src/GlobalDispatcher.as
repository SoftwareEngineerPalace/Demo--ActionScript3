package 
{
	import flash.events.EventDispatcher;
	
	public class GlobalDispatcher extends EventDispatcher
	{
		private static var dispatcher:GlobalDispatcher = null;
		public function GlobalDispatcher (enforcer:SingletonEnforcer) : void {
			if (!enforcer) {
				throw new Error("Direct instatiation is not allowed");
			}
			return;
		}// end function
		
		
		public static function GetInstance() : GlobalDispatcher {
			if (!dispatcher) {
				dispatcher= new GlobalDispatcher (new SingletonEnforcer());
			}// end if
			return dispatcher;
		}// end function
	}
}
class SingletonEnforcer {}
