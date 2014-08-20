package com.safespeed.minesweeper.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class GridEvent extends Event 
	{
		public static const EMPTY_TILES_UNCOVERED:String = 'emptyTilesUncovered';
		
		public function GridEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new GridEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GridEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}