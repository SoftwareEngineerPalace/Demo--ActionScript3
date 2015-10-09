package com.vox.interfaces
{
	public interface IRedoableCommand extends ICommand
	{
		function redo():void ;
	}
}