package code{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * ScoreManager class
	 * Manages the scoring system for the game
	 */
	public class ScoreManager{
		public var so:SharedObject = SharedObject.getLocal("localscore");
		
		/*
		* Constructs a new score manager
		*/
		public function ScoreManager(){
			if (so.size == 0){
				// Default highscore
				so.data.highscore = [{user:"Bob", score:20}];
				so.flush();
			}
		}
		
		// Adds a score to the score list
		public function addScore(n:String, s:Number):void{
			so.data.highscore.push({user:n, score:s});
			so.flush(); // Save to disk
		}
		
		// View highscore
		public function viewScore():void{
			so.data.highscore.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			var i:int = 0;
			for (i = 0; i < so.data.highscore.length; i++){
				if(i <= 9){
					trace(so.data.highscore[i].user, so.data.highscore[i].score);
				}
			}
		}
		
		// Returns top 10 high scores
		public function getScores():String{
			so.data.highscore.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			var scoreString:String = "";
			
			for (var i:int = 0; i < so.data.highscore.length; i++){
				if(i <= 9){
					scoreString += (so.data.highscore[i].user + " " + so.data.highscore[i].score + "\n");
				}
			}
			return scoreString;
		}
		
		// Delete minimum score
		public function deleteMinScore(m:Number):void{
			so.data.highscore.sortOn("score", Array.NUMERIC | Array.DESCENDING);
			var i:int = 0;
			for (i = 0; i < m; i++){
				so.data.highscore.pop();
			}
			so.flush();
		}
	}
}