package com.vox.interfaces
{
	public interface IUndoableCommand extends ICommand
	{
		function undo():void ;
	}
}