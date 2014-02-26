package code{
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * HUDLayer class:
	 * 	Represents the player's Heads Up Display
	 */
	public class HUDLayer extends MovieClip{
		// Dynamic text fields
		public var score_txt:TextField;
		public var lives_txt:TextField;
		public var bomb_txt:TextField;
		public var timer_txt:TextField;
		public var level_txt:TextField;
		
		// Dynamic game data
		protected var _score:int = 0;
		protected var _lives:int;
		protected var _health:int = 100;
		protected var _levelNum:int = 1;
		protected var bombNum:int = 0;
		private var maxOX:Number = 1000;
		private var currentOX:Number = maxOX;
		private var percentOX:Number = currentOX / maxOX;
		
		/*
		* Constructs a new HUDLayer with a certain number of lives
		* for the player
		*/
		public function HUDLayer(lives:int){
			_lives = lives;
			
			// Inits text fields
			lives_txt.text = "Lives: " + _lives.toString();
			score_txt.text = "Score: " + _score.toString();
			bomb_txt.text = "Bombs: 0";
		}
		
		/*
		* Returns the player's current score
		*/
		public function get score():uint { return _score; }
		
		/*
		* Sets the player's current score
		*/
		public function set score(amount:uint):void{
			_score = amount;
			score_txt.text = "Score: " + _score.toString();
		}
		
		/*
		* Returns the player's current number of lives
		*/
		public function get getLives():uint { return _lives; }
		
		/*
		* Sets the player's current number of lives
		*/
		public function set lives(amount:uint):void{
			_lives = amount;
			lives_txt.text = "Lives: " + _lives;
		}
		
		/*
		* Sets the player's bomb amount
		*/
		public function set bombText(bombMessage:String):void{
			bomb_txt.text = bombMessage;
		}
		
		/*
		* Sets the Level text area
		*/
		public function set levelText(levelNum:int){ 
			_levelNum = levelNum;
			level_txt.text =  "Level: : " + levelNum.toString();
		}
		
		/*
		* Alters the player's score
		*/
		public function alterScore(amount:uint, increase:Boolean):void{
			if(increase){
				_score += amount;
			}else{
				_score -= amount;
			}
			
			score_txt.text = "Score: " + _score.toString();
		}
		
		/*
		* Alters the player's lives
		*/
		public function alterLives(increase:Boolean):void{
			if(increase){
				_lives++;
			}else{
				_lives--;
			}
			lives_txt.text = "Lives: " + _lives;
		}
		
		/*
		* Updates the player's oxygen bar
		*/
		public function updateOxygenBar(current_num:Number){
			currentOX = current_num;
			percentOX = currentOX / maxOX;
     		oxygen_bar.scaleX = percentOX;
		}
	}
}