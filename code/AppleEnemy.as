package code{
	import flash.utils.Timer;
	import flash.events.*;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * AppleEnemy class:
	 * 	Represents an apple enemy
	 */
	public class AppleEnemy extends Enemy{
		private var shootTimer:Timer;

		/*
	 	* Constructs a new apple enemy with a certain type, difficulty, if it
		* is a child or parent enemy, and a game screen
	 	*/
		public function AppleEnemy(type:String, enemyDifficulty:int, childEnemy:Boolean, aGameScreen:GameScreen){
			super(type, enemyDifficulty, childEnemy, aGameScreen);
			x = Math.random() * 1100;
			y = 150 + (Math.random() * 300);
			
			gotoAndStop("apple");
		
			// Shoots every 2 seconds
			shootTimer = new Timer(2000, 0);
			shootTimer.addEventListener(TimerEvent.TIMER, shoot);
			shootTimer.start();
		}
		
		/*
	 	* Spawns a bullet with a probability
	 	*/
		private function shoot(e:Event):void{
			if(isAlive){
				if(Math.random() < .3){
					aGameScreen.addBullet(x, y, false, false);
				}
			}else{
				shootTimer.removeEventListener(TimerEvent.TIMER, shoot);
			}
		}
	}
}