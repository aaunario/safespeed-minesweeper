package com.safespeed.minesweeper.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class TileEvent extends Event 
	{
		public static const MINE_TRIPPED:String = "mineTripped";
		public static const MINE_MARKED:String = "mineMarked";
		public static const MINE_UNMARKED:String = "mineUnmarked";
		public static const TILE_CLICKED:String = "tileClicked";
		
		public function TileEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
	}

}