package code{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * Enemy class
	 *	Represents an enemy in the game game.
	 *	Handles enemy movement, enemy difficulty, and enemy type
	 */
	public class Enemy extends MovieClip{
		protected var type:String;
		protected var _isAlive:Boolean = true;
		protected var difficulty:int;
		protected var aGameScreen:GameScreen;
		protected var childEnemy:Boolean
		
		/*
		* Constructs a new enemy with a certain type, difficulty,
		* if it is a child or parent enemy, and a specific game screen
		*/
		public function Enemy(type:String, difficulty:int, childEnemy:Boolean, aGameScreen:GameScreen){
			this.type = type;
			this.difficulty = difficulty;
			this.aGameScreen = aGameScreen;
			this.childEnemy = childEnemy;
		}
		
		
		/*
		* Returns if the enemy is alive or not
		*/
		public function get isAlive():Boolean{ return _isAlive; }
		
		/*
		* Sets the isAlive status of an enemy
		*/
		public function set isAlive(status:Boolean){ _isAlive = status; }
		
		/*
		* Returns if the enemy is a child of another enemy or not
		*/
		public function get isChildEnemy():Boolean{ return childEnemy; }
		
		/*
		* Returns the type of the enemy
		*/
		public function get getType():String{ return type; }
		
		/*
		* Moves the enemy closer to the player's coordinates
		* with a certain probability
		*/
		public function moveEnemy(playerX:Number, playerY:Number):void{
			if(isAlive){
				// Reposition enemy
				if(playerX > x){
					if(Math.random() < .2){
						x++;
					}
				}else{
					if(Math.random() < .35){
						x--;
					}
				}
				
				if(playerY > y){
					if(Math.random() < .2){
						y++;
					}
				}else{
					if(Math.random() < .35){
						y--;
					}
				}
				
				// Wrap enemy on X
				if(x < 0 - (width * 0.5 )){
					x = stage.stageWidth + width * 0.5;
				}
				else if(x > stage.stageWidth + (width * 0.5 )){
					x = 0 - (width * 0.5 );
				}
					
				// Wrap enemy on Y
				if(y < 0 - (height * 0.5 )){
					y = stage.stageHeight + height * 0.5;
				}
				else if(y > stage.stageHeight + (height * 0.5)){
					y = 0 - (height * 0.5);
				}
			}
		}
	}
}