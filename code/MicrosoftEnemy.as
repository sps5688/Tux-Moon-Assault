package code{
	import flash.utils.Timer;
	import flash.events.*;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * MicrosoftEnemy class:
	 * 	Represents an microsoft enemy
	 */
	public class MicrosoftEnemy extends Enemy{
		private var shootTimer:Timer;
		
		/*
	 	* Constructs a new microsoft enemy with a certain type, difficulty, if it
		* is a child or parent enemy, and a game screen
	 	*/
		public function MicrosoftEnemy(type:String, enemyDifficulty:int, childEnemy:Boolean,
									   aGameScreen:GameScreen, coordX:int, coordY:int){
			super(type, enemyDifficulty, childEnemy, aGameScreen);
			
			// If the enemy is a child enemy,
			// spawn  the child enemy at the parent enemies coordinates
			if(!childEnemy){
				x = Math.random() * 1100;
				y = 150 + (Math.random() * 300);
				
				// Child enemies shoot every half second
				shootTimer = new Timer(500, 0);
			}else{
				x = coordX + (Math.random() * 25);
				y = coordY - (Math.random() * 25);
				this.scaleX = .7;
				this.scaleY = .7;
				
				// Parent enemies shoot every 2 seconds
				shootTimer = new Timer(2000, 0);
			}
			
			gotoAndStop("microsoft");
			
			shootTimer.addEventListener(TimerEvent.TIMER, shoot);
			shootTimer.start();
		}
		
		/*
	 	* Spawns a bullet with a probability
	 	*/
		private function shoot(e:Event):void{
			if(isAlive){
				if(Math.random() < .90){
					aGameScreen.addBullet(x, y, false, false);
				}
			}else{
				shootTimer.removeEventListener(TimerEvent.TIMER, shoot);
			}
		}
	}
}