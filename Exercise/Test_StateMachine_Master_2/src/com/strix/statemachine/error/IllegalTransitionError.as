package com.strix.statemachine.error
{
    public class IllegalTransitionError extends Error
    {
        public function IllegalTransitionError(message:*="", id:*=0)
        {
            super(message, id);
        }
    }
}