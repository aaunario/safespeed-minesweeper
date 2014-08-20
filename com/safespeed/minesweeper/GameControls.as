package com.safespeed.minesweeper 
{
	import com.safespeed.minesweeper.events.GameControlsEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import fl.controls.ComboBox;
	import fl.controls.Button;
	import fl.data.DataProvider;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author Ayrris Aunario
	 */
	public class GameControls extends Sprite 
	{
		private const LEVEL_EASY:String = "easy";
		private const LEVEL_MEDIUM:String = "medium";
		private const LEVEL_HARD:String = "hard";
		private const LEVEL_CUSTOM:String = "custom";
		
		private const NUM_COLUMNS_EASY:int = 9;
		private const NUM_ROWS_EASY:int = 9;
		private const NUM_MINES_EASY:int = 10;

		private const NUM_COLUMNS_MEDIUM:int = 16;
		private const NUM_ROWS_MEDIUM:int = 16;
		private const NUM_MINES_MEDIUM:int = 40;

		private const NUM_COLUMNS_HARD:int = 24;
		private const NUM_ROWS_HARD:int = 20;
		private const NUM_MINES_HARD:int = 99;
		
		private const MIN_COLUMNS:int = 1;
		private const MIN_ROWS:int = 1;
		private const MIN_MINES:int = 1;
		
		private const MAX_ROWS:int = 30;
		private const MAX_COLUMNS:int = 30;

		public var levelPicker:ComboBox;
		public var customGridControls:MovieClip;
		public var newGame_btn:Button;
		public var time_txt:TextField;
		public var mines_txt:TextField;
		
		private var timer:Timer;
		private var unmarkedMinesCount:int;
		
		public function GameControls() 
		{
			super();
			initTimer();
			initLevelPicker();
			initCustomGridControls();
			newGame_btn.addEventListener(MouseEvent.CLICK, newGameClickHandler);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			//request easy game as default
			requestNewGame();			
		}
		
		public function startTimer():void {
			trace('timer start');
			this.timer.start();
		}
		
		public function stopTimer():void {
			trace('timer stop');
			this.timer.stop();
		}
		
		public function getTimeElapsed():int {
			return this.timer.currentCount;
		}
		
		private function initTimer():void {
			this.timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function resetTimer():void {
			trace('resetTimer()');
			this.timer.reset();
			this.time_txt.text = this.timer.currentCount.toString();
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			this.time_txt.text = this.timer.currentCount.toString();
		}
		
		private function newGameClickHandler(e:MouseEvent):void 
		{
			requestNewGame();
		}
		
		private function initLevelPicker():void 
		{
			var levels:Array = [
				{label: "Easy", data: LEVEL_EASY },
				{label: "Medium", data: LEVEL_MEDIUM },
				{label: "Hard", data: LEVEL_HARD },
				{label: "Custom", data: LEVEL_CUSTOM }
			];
			levelPicker.dataProvider = new DataProvider(levels);
			levelPicker.addEventListener(Event.CHANGE, levelPickerChangeHandler);
			
			//pick the first option by default
			levelPicker.selectedItem = levels[0];
		}
		
		private function levelPickerChangeHandler(e:Event):void 
		{
			requestNewGame();
		}
		
		private function requestNewGame():void {
			resetTimer();	
			
			var picked:String = levelPicker.selectedItem.data;
			customGridControls.visible = picked == LEVEL_CUSTOM;
			
			var numCols:int;
			var numRows:int;
			var numMines:int;
			if (picked != "custom") {
				numCols = this["NUM_COLUMNS_" + picked.toUpperCase()];
				numRows = this["NUM_ROWS_" + picked.toUpperCase()];
				numMines = this["NUM_MINES_" + picked.toUpperCase()];
				
				newGame_btn.enabled = true;
				if (!customGridControls.makeGrid_btn.enabled)
					setDefaultCustomGridControls();
			} else {
				numCols = int(customGridControls.columns.text);
				numRows = int(customGridControls.rows.text);
				numMines = int(customGridControls.mines.text);
			}
			
			this.unmarkedMinesCount = numMines;
			mines_txt.text = this.unmarkedMinesCount.toString();
			
			if (newGame_btn.enabled) 				
				dispatchEvent(new GameControlsEvent(GameControlsEvent.LEVEL_PICKED, numCols, numRows, numMines));			
		}
		
		public function decrementUnmarkedMines():void {
			this.unmarkedMinesCount--;
			this.mines_txt.text = this.unmarkedMinesCount.toString();
		}

		public function incrementUnmarkedMines():void {
			this.unmarkedMinesCount++;
			this.mines_txt.text = this.unmarkedMinesCount.toString();
		}

		private function initCustomGridControls():void 
		{
			customGridControls.visible = false;
			setDefaultCustomGridControls();
			customGridControls.addEventListener(Event.CHANGE, textChangeHandler);
			customGridControls.makeGrid_btn.addEventListener(MouseEvent.CLICK, makeGridClickHandler);
		}
		
		private function setDefaultCustomGridControls():void 
		{
			customGridControls.columns.text = NUM_COLUMNS_EASY;
			customGridControls.rows.text = NUM_ROWS_EASY;
			customGridControls.mines.text = NUM_MINES_EASY;
			customGridControls.makeGrid_btn.enabled = true;
		}
		
		private function makeGridClickHandler(e:MouseEvent):void 
		{
			requestNewGame();
		}
		
		private function textChangeHandler(e:Event):void 
		{
			// enable/disable ability to make grid and start new game based on validity of input values 
			var numCols:int = int(customGridControls.columns.text);
			var numRows:int = int(customGridControls.rows.text);
			var numMines:int = int(customGridControls.mines.text);
			
			var maxMinesAllowed:int = numCols * numRows / 3; //allow maximum of 1/3 of tiles to have mines
			newGame_btn.enabled = customGridControls.makeGrid_btn.enabled = (numCols <= MAX_COLUMNS && numCols >= MIN_COLUMNS && numRows <= MAX_ROWS && numRows >= MIN_ROWS && numMines <= maxMinesAllowed && numMines >= MIN_MINES);
		}
	}
}