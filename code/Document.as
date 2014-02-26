package code{
	import flash.display.MovieClip;
	import flash.text.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import com.as3toolkit.ui.Keyboarder;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * Document class:
	 * 	The main class for the document.
	 */
	public class Document extends MovieClip{
		// Game data
		private static const XML_PATH:String = "data/data.xml";
		private var pLoader:URLLoader;
		private var request:URLRequest;
		private var _kb:Keyboarder;
		
		// Game Play
		private var _gameScreen:GameScreen;
		private var _hudLayer:HUDLayer;
		private var previousScreen:String = "";
		private var channel:SoundChannel;
		
		// High Score system
		private var _scoreManager:ScoreManager;
		private var playerScore:int;
		private var inputField:TextField;
		
		/*
		 * Document class constructor
		 */
		public function Document(){
			// Manages scoring system
			_scoreManager = new ScoreManager();
			
			// Init input
			_kb = new Keyboarder(this);
			
			// Add EventListeners
			Start_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
			highScoreBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			Credits_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleCreditsBtn);
			
			// Stop timeline animation
			stop();
		}
		
		/*
		 * Getter for score manager
		 */
		public function get scoreManager():ScoreManager{return _scoreManager;}
		
		/*
		 * Parses XML file when XML is loaded
		 * and sets up the game
		 */
		private function onXMLLoaded(e:Event):void{
			// Parse XML
			var myXML = new XML(e.target.data);
			var enemyNum:int = myXML.enemy.number;
			var enemyDiff:int = myXML.enemy.difficulty;
			var tokenNum:int = myXML.tokens.number;
			var livesNum:int = myXML.player.lives;
			var requiredBombScore = myXML.power_ups.bomb_score;
			
			// Init Game
			_gameScreen = new GameScreen(enemyNum, enemyDiff, tokenNum, livesNum, requiredBombScore);
			_gameScreen.init();
			addChild(_gameScreen);
			
			// Focus the screen
			stage.stageFocusRect = false;
			stage.focus = _gameScreen;
			
			// Go to game screen
			previousScreen = "game";
			gotoAndStop("game");
		}
		
		/*
		 * Handles the start button action to begin the game
		 */
		private function handleStartBtn(e:Event):void{
			// Remove EventListeners
			if(previousScreen == "instructions"){
				Accept_Mission_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
				backBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleBackBtn);
			}else{
				Start_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
				Instructions_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
				highScoreBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			}
			
			// Load XML
			pLoader = new URLLoader();
			request = new URLRequest(XML_PATH);
			pLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
			pLoader.load(request);
		}
		
		/*
		 * Handles the instructions screen button
		 * and takes the player to the instruction screen
		 */
		private function handleInstructionsBtn(e:Event):void{
			// Remove EventListeners
			Start_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);

			// Go to instructions screen
			previousScreen = "instructions";
			gotoAndStop("instructions");
			
			// Add EventListeners
			Accept_Mission_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleBackBtn);
		}
		
		/*
		 * Handles the high score screen button
		 * and takes the player to the high score screen
		 */
		public function handleHighScoreBtn(e:Event):void{
			// Remove EventListeners
			Start_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
			highScoreBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			
			// Go to highscores screen
			previousScreen = "highscores";
			gotoAndStop("highscores");
			
			// Add EventListeners
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleBackBtn);
			
			// Display scores
			scoreTxtField.text = _scoreManager.getScores();
		}
		
		/*
		 * Handles the credits screen button
		 * and takes the player to the credits screen
		 */
		public function handleCreditsBtn(e:Event){
			// Remove EventListeners
			Start_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
			highScoreBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			Credits_Btn.removeEventListener(MouseEvent.MOUSE_DOWN, handleCreditsBtn);
			
			// Go to credits screen
			previousScreen = "credits";
			gotoAndStop("credits");
			
			// Add EventListeners
			backBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleBackBtn);
		}
		
		/*
		 * Handles the replay button when the game is over
		 * and takes the player back to the menu screen
		 */
		public function handleReplayBtn(e:Event):void{
			// Remove EventListeners
			replayBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleReplayBtn);
			addScoreBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleAddScoreBtn);

			inputField.text = "";
			removeChild(inputField);

			// Go to menu screen
			previousScreen = "menu";
			gotoAndStop("menu");
			
			// Add EventListeners
			Start_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
			highScoreBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			Credits_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleCreditsBtn);
		}
		
		/*
		 * Handles the add score button that is 
		 * displayed when the game is over and then
		 * takes the player to the menu screen
		 */
		public function handleAddScoreBtn(e:Event):void{
			_scoreManager.addScore(inputField.text, playerScore);
			
			// Remove EventListeners
			replayBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleReplayBtn);
			addScoreBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleAddScoreBtn);
			
			inputField.text = "";
			removeChild(inputField);
			
			previousScreen = "menu";
			gotoAndStop("menu");
			
			// Add EventListeners
			Start_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
			highScoreBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			Credits_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleCreditsBtn);
		}
		
		/*
		 * Handles the back button on various screens
		 * and takes the player back to the menu screen
		 */
		public function handleBackBtn(e:Event):void{
			// Remove EventListeners
			backBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleBackBtn);
			
			previousScreen = "menu";
			gotoAndStop("menu");
			
			// Add EventListeners
			Start_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleStartBtn);
			Instructions_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleInstructionsBtn);
			highScoreBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleHighScoreBtn);
			Credits_Btn.addEventListener(MouseEvent.MOUSE_DOWN, handleCreditsBtn);
		}
		
		/*
		 *  Takes the player to the score screen when a game is over
		 */
		public function gotoScoreScreen(playerScore:int):void{
			// Removes the gamescreen
			removeChild(_gameScreen);
			
			// Populate score screen
			previousScreen = "score";
			gotoAndStop("score");
			
			// Display Scores
			this.playerScore = playerScore;
			playerScore_txt.text = "Your score is: " + playerScore;
			highscore_txt.text = _scoreManager.getScores();
			
			inputField = new TextField();
			
			var format1:TextFormat = new TextFormat();
    		format1.font = "Arial";
    		format1.size = 24;
			
			inputField.defaultTextFormat = format1;
			inputField.border = true;
			inputField.width = 200;
			inputField.height = 150;
			inputField.x = 610;
			inputField.y = 210;
			inputField.textColor = 0xFFFFFF;
			inputField.backgroundColor = 0xFFF000;
			inputField.height = 30;
			inputField.text = "";
			inputField.type = "input";
			
			addChild(inputField);
			stage.focus = inputField;
			
			// Add EventListeners
			replayBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleReplayBtn);
			addScoreBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleAddScoreBtn);
		}
	}
}