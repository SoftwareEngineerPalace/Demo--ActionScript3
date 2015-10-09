package com.strix.statemachine.error
{
    public class TransitionExistsError extends Error
    {
        public function TransitionExistsError(message:*="", id:*=0)
        {
            super(message, id);
        }
    }
}