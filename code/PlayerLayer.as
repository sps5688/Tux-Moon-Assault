package code{
	import com.as3toolkit.events.KeyboarderEvent;
	import com.as3toolkit.ui.Keyboarder;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * PlayerLayer class
	 *	Represents the player layer of a game.
	 *	Handles player-keyboard interactions
	 */
	public class PlayerLayer extends Sprite{
		public var _player:Player;
		public var gameScreen:GameScreen;
		private var availableBombs:int = 0;
		private var bombDelayCounter = 0;
		private var bombDelayTimer:Timer;

		/*
		* Inits the player layer with a specific game screen
		* and creates the player
		*/
		public function PlayerLayer(aGameScreen:GameScreen){
			gameScreen = aGameScreen;
			_player = new Player();
			addChild(_player);
			
			// Start bomb delay timer to prevent using
			// 2 bombs at once
			bombDelayTimer = new Timer(1000, 0);
			bombDelayTimer.addEventListener(TimerEvent.TIMER, bombDelay);
			bombDelayTimer.start();
		}
		
		/*
		* Gets the current number of bombs the player has to use
		*/
		public function get bombNum():int{ return availableBombs; }
		
		/*
		* Alters the current number of bombs the player has to use
		*/
		public function alterBombNum(increase:Boolean){
			if(increase){
				availableBombs++;
			}else{
				availableBombs--;
			}
		}
		
		/*
		* Simualtes a delay when the player uses a bomb,
		* this prevents them from using two bombs at once
		*/
		private function bombDelay(e:Event):void{
			if(bombDelayCounter > 0){
				bombDelayCounter--;
			}
		}
		
		/*
		* Monitors the keyboard for key presses
		* and reactions accordingly
		*/
		public function pollKeyboard():void{
			// Movement
			if(Keyboarder.keyIsDown(Keyboard.W)){
				_player.jump();
			}
			
			if(!Keyboarder.keyIsDown(Keyboard.W)){
				_player.killJet();
			}
			
			if(Keyboarder.keyIsDown(Keyboard.A)){
				_player.moveLeft();
			}
			
			if(Keyboarder.keyIsDown(Keyboard.D)){
				_player.moveRight();
			}
			
			// Firing
			if (Keyboarder.keyIsDown(Keyboard.LEFT)){
				gameScreen.addBullet(_player.x, _player.y, true, false)
			}
			
			if(Keyboarder.keyIsDown(Keyboard.RIGHT)){
				gameScreen.addBullet(_player.x, _player.y, true, true)
			}
			
			// Powerup
			if(Keyboarder.keyIsDown(Keyboard.SPACE) && availableBombs > 0){
				if(bombDelayCounter < 1){
					bombDelayCounter++;
					gameScreen.deployBomb();
				}
			}
		}
	}
}