package code{
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * Player class
	 *	Represents a player in the game.
	 *	Handles the player-gravity-jetpack-screen-oxygen interactions
	 */
	public class Player extends MovieClip{
		private var gravityTimer:Timer;
		private var _isAlive = true;
		private var oxygen:int = 1000;
		
		private var timeCounter:Number = 0;
		private var mooonAcceleration:Number = 0.015;
		private var jetAcceleration:Number = 0;
		
		// Physics Flags!!
		private var falling:Boolean = false;
		private var reachedMaxHeight:Boolean = false;
		private var onBottom:Boolean = true;
		
		private static var TIME_INCREMENT:Number = 0.5;
		private var BOTTOM_SCREEN_THRESHOLD:int = 763;
			
		/*
	 	* Constructs a new player for the game
	 	*/
		public function Player(){
			// Bottom Left of screen
			respawn();
			
			gravityTimer = new Timer(TIME_INCREMENT, 0);
			gravityTimer.addEventListener(TimerEvent.TIMER, gravityAdjust);
			gravityTimer.start();
		}
		
		/*
	 	* Gets if the player is alive or not
	 	*/
		public function get isAlive():Boolean{ return _isAlive; }
		
		/*
	 	* Gets the player's current oxygen amount
	 	*/
		public function get oxygenAmount():int{ return oxygen; }
		
		/*
	 	* Adjusts the players position based on gravity
		* and the jet pack's acceleration
	 	*/
		private function gravityAdjust(e:TimerEvent):void{
			// If at bottom of screen
			if(y >= BOTTOM_SCREEN_THRESHOLD){
				if(!onBottom){
					timeCounter = 0;
					onBottom = true;
				}
			}else{
				onBottom = false;
				timeCounter += TIME_INCREMENT;
			}

			// Calculate new y position
			var newY = y + (0.5 * (mooonAcceleration - jetAcceleration) * (timeCounter * timeCounter));

			if(newY < y){
				reachedMaxHeight = false;
			}

			// Update position
			if(!(newY >= BOTTOM_SCREEN_THRESHOLD)){
				y = newY;
			}else{
				y = BOTTOM_SCREEN_THRESHOLD;
			}
		}
		
		/*
	 	* Resets the player at the bottom left hand
		* corner of the screen
	 	*/
		public function respawn():void{
			x = 50;
			y = BOTTOM_SCREEN_THRESHOLD;
			
			oxygen = 1000;
			_isAlive = true;
		}
		
		/*
	 	* Moves the player left
	 	*/
		public function moveLeft():void{
			x -= 10;
			wrapAdjust();
		}
		
		/*
	 	* Moves the player right
	 	*/
		public function moveRight():void{
			x += 10;
			wrapAdjust();
		}
		
		/*
	 	* Moves the player up based on the jet pack's
		* acceleration and gravity
	 	*/
		public function jump():void{
			gotoAndPlay("jetpack");
			timeCounter += TIME_INCREMENT;
			
			// Falling has changed
			if(falling != false){
				falling = false;
				timeCounter = 0;
			}
			
			jetAcceleration = 2 * mooonAcceleration;
		}
		
		/*
	 	* Kills the jetpack's influence on the
		* player's position
	 	*/
		public function killJet():void{
			gotoAndStop("normal");
			
			// Falling has changed
			if(falling != true){
				falling = true;
			}
			
			if(jetAcceleration > 0){
				if(jetAcceleration <= mooonAcceleration && reachedMaxHeight == false){
					reachedMaxHeight = true;
					timeCounter = 20;
				}
				jetAcceleration -= 0.08 * mooonAcceleration;
			}
			
			if(timeCounter != 0){
				timeCounter -= TIME_INCREMENT;
			}
		}
		
		/*
	 	* Allows the player to wrap around the screen
		* from right to left or left to right
	 	*/
		private function wrapAdjust():void{
			// Wrap enemy on X
			if (x < 0 - (width * 0.5)){
				x = stage.stageWidth + width * 0.5;
			}
			else if (x > stage.stageWidth + (width * 0.5)){
				x = 0 - ( width * 0.5 );
			}
					
			// Wrap enemy on Y
			if (y < 0 - (height * 0.5)){
				y = stage.stageHeight + height * 0.5;
			}
			else if (y > stage.stageHeight + (height * 0.5)){
				y = 0 - (height * 0.5);
			}
		}
		
		/*
	 	* Uses some of the player's oxygen supply
	 	*/
		public function useOxygen():void{
			oxygen -= Math.random() * 7;
			if(oxygen <= 0){
				_isAlive = false;
			}
		}
		
		/*
	 	* Add some oxygen to the player's oxygen supply
	 	*/
		public function addOxygen(amount:Number):void{
			oxygen += amount;
		}
	}
}