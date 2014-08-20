package com.safespeed.minesweeper 
{
	import com.safespeed.minesweeper.events.GridEvent;
	import com.safespeed.minesweeper.events.TileEvent;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class Grid extends Sprite 
	{
		private var tiles:Vector.<Tile>;
		private var gridWidth:int;
		private var gridHeight:int;
		private var numMines:int;

		public function Grid(width:int, height:int, numMines:int) 
		{
			super();
			this.gridHeight = height;
			this.gridWidth = width;
			addListeners();
			initTiles(width, height, numMines);
		}
		
		public function disableClicks():void {
			for each (var tile:Tile in tiles) {
				tile.removeListeners();
			}
		}
		
		public function revealMines():void {
			for each (var tile:Tile in tiles) {
				if (tile.hasMine) 
					tile.cover.visible = false;
			}
		}
		
		private function addListeners():void {
			addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
			addEventListener(TileEvent.TILE_CLICKED, tileClickedHandler);
		}
		
		private function rightClickHandler(e:MouseEvent):void 
		{
			//do nothing (prevent default context menu from popping up)
		}
		
		private function removeListeners():void {
			removeEventListener(TileEvent.TILE_CLICKED, tileClickedHandler);
			removeEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
		}
		
		private function tileClickedHandler(e:TileEvent):void 
		{
			//see if all empty tiles have been uncovered
			var hasCoveredEmptyTiles:Boolean = false;
			for each (var tile:Tile in tiles) {
				if (!tile.hasMine && tile.cover.visible) {
					hasCoveredEmptyTiles = true;
					break;
				}
			}
			
			if (!hasCoveredEmptyTiles) 
				dispatchEvent(new GridEvent(GridEvent.EMPTY_TILES_UNCOVERED));
		}
				
		private function initTiles(width:int, height:int, numMines:int):void {
			this.tiles = new Vector.<Tile>();
			var tile:Tile;
			var neighbor:Tile;
			var i:int;
			var j:int;
			
			//create and place tiles
			for (i = 0; i < height; i++) {
				for (j = 0; j < width;  j++) {
					tile = new Tile();
					tile.x = tile.width * j;
					tile.y = tile.height * i;
					addChild(tile);
					tiles.push(tile);
				}
			}
			
			setNeighbors();

			//set mines
			var randomized:Vector.<Tile> = this.tiles.concat().sort(randomize); //create copy of tiles array and randomize that
			for (i = 0; i < numMines; i++) {
				randomized.pop().hasMine = true;
			}
			
			//set adjacent count
			for each (tile in this.tiles) {
				tile.setAdjacentCount();
			}
		}
		
		private function setNeighbors():void {
			var tile:Tile;
			var neighbor:Tile;
			var neighborX:int;
			var neighborY:int;
			for (var gridX:int = 0; gridX < this.gridWidth; gridX++) {
				for (var gridY:int = 0; gridY < this.gridHeight;  gridY++) {
					tile = getTile(gridX, gridY);
					
					for (var i:int = -1; i <= 1; i++) {
						neighborX = gridX + i;
						if (neighborX < 0 || neighborX == this.gridWidth)
							continue;
						for (var j:int = -1; j <= 1; j++) {
							neighborY = gridY + j;
							if (neighborY < 0 || neighborY == this.gridHeight)
								continue;
							neighbor = getTile(neighborX, neighborY);
							if (neighbor != tile)
								tile.neighbors.push(neighbor);
						}
					}
				}
			}
		}
		
		private function getTile(gridX:int, gridY:int):Tile {
			var index = int(gridY * this.gridWidth) + (gridX % this.gridWidth);
			return this.tiles[index];
		}
		
		//compare function used with Array.sort() to randomize the elements of the array
		private function randomize(a:*, b:*):int {
			return (Math.random() < 0.5) ? -1 : 1;
		}
		
		public function destroy():void {
			for each (var tile:Tile in tiles) {
				tile.destroy();
			}
			this.tiles = null;
			removeListeners();
		}
	}
}