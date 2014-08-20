package com.safespeed.minesweeper.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class GameControlsEvent extends Event 
	{
		public static const LEVEL_PICKED:String = 'levelPicked';
		public static const NEW_GAME_CLICKED:String = 'newGameClicked';
		
		private var _numColumns:int;
		private var _numRows:int;
		private var _numMines:int;
		
		public function GameControlsEvent(type:String, numColumns:int = 9, numRows:int = 9, numMines:int = 10) 
		{ 
			super(type, bubbles, cancelable);
			this._numColumns = numColumns;
			this._numRows = numRows;
			this._numMines = numMines;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameControlsEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get numColumns():int 
		{
			return _numColumns;
		}
		
		public function get numRows():int 
		{
			return _numRows;
		}
		
		public function get numMines():int 
		{
			return _numMines;
		}
		
	}
	
}