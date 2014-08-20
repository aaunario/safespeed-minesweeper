package com.safespeed.minesweeper 
{
	import com.safespeed.minesweeper.events.TileEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class Tile extends Sprite 
	{
		public var numAdjacent_txt:TextField;
		
		private var _hasMine:Boolean;
		private var _neighbors:Vector.<Tile>;
		private var _adjacentCount:int;
		
		private var coverMarkers:Array = ["", "M", "?"];
		
		public var cover:MovieClip;
		
		public function Tile() 
		{
			super();
			this._neighbors = new Vector.<Tile>();
			addListeners();
			
			//for debug
			//this.cover.alpha = 0.6;
		}
		
		public function setAdjacentCount():void {
			if (_hasMine) return;
			var count:int = 0;
			for each (var tile:Tile in neighbors) {
				if (tile.hasMine)
					count++;
			}
			this._adjacentCount = count;
			if (count) 
				this.numAdjacent_txt.text = count.toString();
			else
				removeChild(this.numAdjacent_txt); //show no text if there are no neighbors with mines
		}
				
		private function addListeners():void {
			cover.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
			cover.addEventListener(MouseEvent.CLICK, clickHandler);			
		}
		
		public function removeListeners():void {
			cover.removeEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
			cover.removeEventListener(MouseEvent.CLICK, clickHandler);						
		}
		
		private function rightClickHandler(e:MouseEvent):void 
		{
			//toggle markers (marked, ?, unmarked)
			var index:int = coverMarkers.indexOf(cover.marker_txt.text);
			cover.marker_txt.text = coverMarkers[(index + 1) % coverMarkers.length];
			if (cover.marker_txt.text == "M")
				dispatchEvent(new TileEvent(TileEvent.MINE_MARKED));
			else if (cover.marker_txt.text == "?")
				dispatchEvent(new TileEvent(TileEvent.MINE_UNMARKED));
		}
		
		private function clickHandler(e:MouseEvent):void 
		{
			if (cover.marker_txt.text == "M")  //disable clicking on marked tiles
				return;
				
			if (!_hasMine) {				
				revealArea();
				dispatchEvent(new TileEvent(TileEvent.TILE_CLICKED));
			} else {
				dispatchEvent(new TileEvent(TileEvent.MINE_TRIPPED));
				addChild(new TrippedTile());
			}
		}
				
		public function revealArea():void {
			cover.visible = false;
			if (!_adjacentCount) {
				for each (var tile:Tile in this._neighbors) {
					if (tile.cover.visible)
						tile.revealArea();
				}
			}
		}
		
		public function get hasMine():Boolean 
		{
			return _hasMine;
		}
		
		public function set hasMine(value:Boolean):void 
		{
			_hasMine = value;
			if (_hasMine)
				numAdjacent_txt.text = "*";
		}
		
		public function get neighbors():Vector.<Tile> 
		{
			return _neighbors;
		}
		
		public function destroy():void {
			this._neighbors = null;
			removeListeners();
		}
	}

}