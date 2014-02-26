package code{
	import flash.display.MovieClip;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * Token class
	 *	Represents either a oxygen or point token
	 */
	public class Token extends MovieClip{
		private var point:Boolean;
		private var tokenValue:int = 0;
		
		/*
		* Constructs a new point or oxygen token
		*/
		public function Token(){
			// Inits location
			x = Math.random() * 950
			y = 150 + (Math.random() * 500);
			
			// Each token type has a 50%
			// chance of being created
			if(Math.random() < 0.5){
				point = true;
				tokenValue = Math.random() * 10;
			}else{
				point = false;
				gotoAndPlay("oxygen");
				tokenValue = 25 + (Math.random() * 25);
			}
		}
		
		/*
		* Returns the value of the token
		*/
		public function get getValue():int{ return tokenValue; }
		
		/*
		* Returns if the token is a point type token or not
		*/
		public function get isPoint():Boolean{ return point; }
	}
}