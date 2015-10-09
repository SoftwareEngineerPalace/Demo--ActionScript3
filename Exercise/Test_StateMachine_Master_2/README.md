statemachine-as3
================

Lightweight state machine based on closures for ActionScript 3


##Flavours
This library comes with two state machine falvours:
 - `StateMachine` where transitions are triggered directly
 - `EventStateMachine` where transitions are triggered by `Event` and `EventDispatcher`

<br><br>

##Usage

###Initialization
```actionscript
//StateMachine
var sm : StateMachine = new StateMachine("process.step1");

//EventStateMachine
var esm : EventStateMachine = new EventStateMachine("process.step1");
```

<br>

###Adding state transitions
```actionscript
//StateMachine
sm.add(
    //From state...
    "process.step1",
    //To state...
    "process.step2",
    //Action-Filter which is triggered on transition
    function() : Boolean {
        //If true is not returned, the transition will not complete
        return true;
    }
);

//EventStateMachine
esm.add(
    //From state...
    "process.step1",
    //To state...
    "process.step2",
    //When the following flash.events.EventDispatcher...
    processDispatcher,
    //Dispatches the flash.events.Event...
    Step2Event,
    //Action-Filter which is triggered on transition
    function( ... Arguments ) : Boolean {
        //Arguments are received from the EventDispatcher
        for each( var argument : * in Arguments ) {
            //...
        }
        
        //If true is not returned, the transition will not complete
        return true;
    }
);
```

<br>

###Activating state transitions
```actionscript
//StateMachine
sm.state = "process.step2";

//EventStateMachine
processDispatcher.dispatch(Step2Event);
```

<br>

###Getting current state
```actionscript
//StateMachine
trace(sm.state);

//EventStateMachine
trace(esm.state);
```

<br>

###Transition success
```actionscript
//StateMachine - attempt to assign new state
var success : Boolean = (sm.state = 'process.step2') == sm.state;
```