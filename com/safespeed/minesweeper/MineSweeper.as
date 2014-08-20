package com.safespeed.minesweeper 
{
	import com.safespeed.minesweeper.events.GameControlsEvent;
	import com.safespeed.minesweeper.events.GridEvent;
	import com.safespeed.minesweeper.events.TileEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class MineSweeper extends Sprite 
	{
		private const HOLDER_Y:int = 50;
		
		private var grid:Grid;
		
		private var gameControls:GameControls;
		private var holder:Sprite; //holds all graphical elements for easy centering
		private var gameEndScreen:GameEndScreen;

		public function MineSweeper() 
		{
			super();
			this.holder = new Sprite();
			this.holder.y = HOLDER_Y;
			addChild(holder);
			addListeners();
			initGameControls();
		}
		
		private function addGameEndScreen(time:int):void 
		{
			this.gameEndScreen = new GameEndScreen();
			addChild(this.gameEndScreen);
			this.gameEndScreen.msg_txt.text = "Hooray!!! \nYou finished in " + time + " seconds."; 
			this.gameEndScreen.close_btn.addEventListener(MouseEvent.CLICK, gameEndScreenCloseClickHandler);
		}
		
		private function gameEndScreenCloseClickHandler(e:MouseEvent):void 
		{
			removeGameEndScreen();
		}

		private function removeGameEndScreen():void 
		{
			removeChild(this.gameEndScreen);
			this.gameEndScreen.close_btn.removeEventListener(MouseEvent.CLICK, gameEndScreenCloseClickHandler);
			this.gameEndScreen = null;
		}
		
		private function initGameControls():void 
		{
			this.gameControls = new GameControls();
			this.gameControls.addEventListener(GameControlsEvent.LEVEL_PICKED, levelPickedHandler);
			this.holder.addChild(this.gameControls);
		}
		
		private function levelPickedHandler(e:GameControlsEvent):void 
		{
			initGrid(e.numColumns, e.numRows, e.numMines);
		}
		
		private function initGrid(width:int, height:int, numMines:int) 
		{
			if (this.grid) {
				removeGridListeners(this.grid);
				this.holder.removeChild(grid);
				this.grid.destroy();
			}
			
			this.grid = new Grid(width, height, numMines);
			addGridListeners(this.grid);
			this.holder.addChild(grid);
			
			positionGameControls();
			centerHolder();
		}
		
		private function addGridListeners(grid:Grid):void 
		{
			grid.addEventListener(TileEvent.TILE_CLICKED, tileClickedHandler);
			grid.addEventListener(GridEvent.EMPTY_TILES_UNCOVERED, emptyTilesUncoveredHandler);
		}

		private function removeGridListeners(grid:Grid):void 
		{
			grid.removeEventListener(GridEvent.EMPTY_TILES_UNCOVERED, emptyTilesUncoveredHandler);
		}

		private function centerHolder():void {
			var bounds:Rectangle = this.holder.getBounds(this);
			var center:Point = new Point(bounds.left + bounds.width / 2, bounds.top + bounds.height / 2);
			this.holder.x += (this.stage.stageWidth / 2 - center.x);
		}
		
		private function positionGameControls():void 
		{
			this.gameControls.x = this.grid.x + this.grid.width + 10;
			this.gameControls.y = this.grid.y;
		}
		
		private function emptyTilesUncoveredHandler(e:GridEvent):void 
		{
			grid.disableClicks();
			
			//show success screen with total time
			this.gameControls.stopTimer();
			addGameEndScreen(this.gameControls.getTimeElapsed());
		}
		
		private function addListeners():void 
		{
			addEventListener(TileEvent.MINE_TRIPPED, mineTrippedHandler);
			addEventListener(TileEvent.MINE_MARKED, mineMarkedHandler);
			addEventListener(TileEvent.MINE_UNMARKED, mineUnmarkedHandler);
		}
		
		private function mineUnmarkedHandler(e:TileEvent):void 
		{
			//keep track of total mines marked
			this.gameControls.incrementUnmarkedMines();			
		}
		
		private function mineMarkedHandler(e:TileEvent):void 
		{
			//keep track of total mines marked
			this.gameControls.decrementUnmarkedMines();
		}
		
		private function tileClickedHandler(e:TileEvent):void 
		{
			this.grid.removeEventListener(TileEvent.TILE_CLICKED, tileClickedHandler);
			
			//start timer
			this.gameControls.startTimer();
		}
		
		private function mineTrippedHandler(e:TileEvent):void 
		{
			this.gameControls.stopTimer();
			grid.disableClicks();
			grid.revealMines();
		}
	}
}