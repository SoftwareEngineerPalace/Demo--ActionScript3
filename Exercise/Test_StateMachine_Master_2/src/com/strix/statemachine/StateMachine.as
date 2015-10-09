package com.strix.statemachine {
    
    import com.strix.statemachine.error.IllegalTransitionError;
    import com.strix.statemachine.error.TransitionExistsError;

    
    public final class StateMachine {
        
        public static const
            INVALID_TRANSITION : Boolean = false,
            STRICT             : Boolean = true;
            
        private var
            currentState   : String,
            actionFilters  : Array,
            strict         : Boolean,
            alwaysTransist : Function = function() : Boolean { return true; }

            
        public function StateMachine( initialState:String, strict:Boolean=false ) {
            this.currentState = initialState;
            this.actionFilters = new Array;
            this.strict = strict;
        }
        
        
        public function add( from:String, to:String, actionFilter:Function=null ) : StateMachine {
            if( actionFilters[from+to] != null ) {
                if( !strict )
                    return this;
                
                throw new TransitionExistsError("Transition '" + from + "' -> '" + to + "' already exists");
            }
            
            actionFilters[from+to] = actionFilter != null ? actionFilter : alwaysTransist;
            
            return this;
        }
        
        public function get state() : String {
            return currentState;
        }
        
        public function set state( newState:String ) : void {
            var actionFilter : Function = actionFilters[currentState+newState];
            
            if( actionFilter == null ) {
                if( !strict )
                    return;
                
                throw new IllegalTransitionError("Transition '" + currentState + "' -> '" + newState + "' is illegal");
            }
            
            if( actionFilter.apply(null) == StateMachine.INVALID_TRANSITION )
                return;
                
            currentState = newState;
        }

    }
    
}