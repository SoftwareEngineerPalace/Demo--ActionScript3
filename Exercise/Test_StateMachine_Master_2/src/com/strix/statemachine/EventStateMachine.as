package com.strix.statemachine {
    
    import com.strix.statemachine.error.IllegalTransitionError;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    
    public final class EventStateMachine {
        
        public static const
            INVALID_TRANSITION : Boolean = false,
            STRICT             : Boolean = true;
            
        private var
            currentState   : String,
            strict         : Boolean,
            alwaysTransist : Function = function() : Boolean { return true; }
        
            
        public function EventStateMachine( initialState:String, strict:Boolean=false ) {
            this.currentState = initialState;
            this.strict = strict;
        }
        
        
        public function add(
            from:String, to:String,
            eventDispatcher:EventDispatcher, onEvent:Event,
            actionFilter:Function=null ) : EventStateMachine {

            eventDispatcher.addEventListener(
                onEvent.type,
                function( ... Arguments ) : void {
                    if( currentState == from ) {
                        if( actionFilter != null && actionFilter.apply(null, Arguments) == EventStateMachine.INVALID_TRANSITION )
                            return;
                        
                        currentState = to;
                    } else if( strict ) {
                        throw new IllegalTransitionError(
                            "Transition '" + from + "' -> '" + to + "' is illegal while in '" + currentState + "'"
                        );
                    }
                }
            );
            
            return this;
        }
        
        public function get state() : String {
            return currentState;
        }

    }
    
}