package code{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.geom.*;
	import flash.display.Shape;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * GameScreen class
	 *	Represents a game screen that various elemements
	 *	will be added.
	 */
	public class GameScreen extends MovieClip{
		// Game layers
		private var _playerLayer:PlayerLayer;
		private var _playerLayerMobile:PlayerLayerMobile;
		private var _hudLayer:HUDLayer;
		private var gameOver:Boolean = false;
		private var moonSurface:Shape;
		
		// XML driven game values
		private var _currentPlayer:Player;
		private var enemyNum:int;
		private var enemyDiff:int;
		private var tokenNum:int
		private var requiredBombScore:int;
		
		// Level and wave counters
		private var levelNum:int = 1;
		private var waveNum:int = 1;
		private const WAVE_SEPARATOR:int = 4;
		
		// Other game variables
		private static const MOBILE:Boolean = false;
		private var playerBullets:int = 0;
		private var bulletDelayTimer:Timer;
		private var bomb:BombSound = new BombSound();
		
		// Data structures
		private var enemyArr:Array = new Array();
		private var bulletArr:Array = new Array();
		private var tokenArr:Array = new Array();
		
		/*
	 	* GameScreen constructor
		*	Initializes the game screen with the number of
		*	enemies, the enemy difficulty, the number of tokens,
		*	the starting number of lives, and the starting 
		*	required score to obtain the bomb powerup.
	 	*/
		public function GameScreen(enemyNum:int, enemyDiff:int, tokenNum:int, startLives:int, requiredBombScore:int){
			// Inits variables
			this.enemyNum = enemyNum;
			this.enemyDiff = enemyDiff;
			this.tokenNum = tokenNum;
			this.requiredBombScore = requiredBombScore;
			
			// Inits screens depending on if being ran on mobile or not
			if(MOBILE){
				_hudLayer = new HUDLayer(startLives);
				_playerLayerMobile = new PlayerLayerMobile(this);
				_currentPlayer = _playerLayerMobile._player;
			}else{
				_hudLayer = new HUDLayer(startLives);
				_playerLayer = new PlayerLayer(this);
				_currentPlayer = _playerLayer._player;
			}
		}
		
		/*
		* Inits game screen by creating the moon graphics,
		* starting the bullet delay timer, and initializing
		* the first level and adding it to the screen
		*/
		public function init():void{
			// Make background
			moonSurface = new Shape;
			moonSurface.graphics.beginFill(0xA39D9F);
			moonSurface.graphics.drawRect(0, 1100 - 500, 1100,400);
			moonSurface.graphics.endFill();
			addChild(moonSurface);
			
			// Timer to simulate bullet delay
			bulletDelayTimer = new Timer(500, 0);
			bulletDelayTimer.addEventListener(TimerEvent.TIMER, bulletDelay);
			bulletDelayTimer.start();
			
			// Init first level
			_hudLayer.levelText = levelNum;
			populateScreen();
			
			// Init game play screens
			addChild(_hudLayer);
			if(!MOBILE){
				addChild(_playerLayer);
			}else{
				addChild(_playerLayerMobile);
			}
			
			// Main game loop
			addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		/*
		 * Spawns smaller Microsoft themed enemies at specific coordinates
		*/
		private function spawnLittleEnemies(coordX:int, coordY:int):void{
			for(var i:int = 0; i < 2; i++){
				var enemy:Enemy = new MicrosoftEnemy("Microsoft", enemyDiff, true,
													 this, coordX, coordY);
				enemyArr.push(enemy);
				addChild(enemy);
			}
		}
		
		/*
		 * Populates the screen with enemies and tokens
		 * based on the current level number
		*/	
		private function populateScreen():void{
			if(waveNum % WAVE_SEPARATOR == 0){
				// Add microsoft enemies
				for(var j:int = 0; j < (levelNum * enemyNum); j++){
					var enemy:Enemy = new MicrosoftEnemy("Microsoft", enemyDiff, false, this, 0, 0);
					enemyArr.push(enemy);
					addChild(enemy);
				}
			}else{
				// Add apple enemies
				for(var i:int = 0; i < (levelNum * enemyNum); i++){
					var iEnemy:Enemy = new AppleEnemy("Apple", enemyDiff, false, this);
					enemyArr.push(iEnemy);
					addChild(iEnemy);
				}
			}
			
			// Add point tokens
			for(var k:int; k < (levelNum * tokenNum); k++){
				var token:Token = new Token();
				tokenArr.push(token);
				addChild(token);
			}
		}
		
		/*
		 * Clears the screen off all enemies, tokens, and bullets
		 * and determines if the game is over
		*/
		private function clearScreen():void{
			// Clear enemies
			for each(var enemy:Enemy in enemyArr){
				var enemyIndex:int = enemyArr.indexOf(enemy);
				enemyArr.splice(enemyIndex, 1);
				enemy.isAlive = false;
				removeChild(enemy);
			}
			
			// Clear tokens
			for each(var token:Token in tokenArr){
				var tokenIndex:int = tokenArr.indexOf(token);
				tokenArr.splice(tokenIndex, 1);
				removeChild(token);
			}
			
			// Clear bullets
			for each(var bullet:Bullet in bulletArr){
				var bulletIndex:int = bulletArr.indexOf(bullet);
				bulletArr.splice(bulletIndex, 1);
				bullet.isAlive = false;
				removeChild(bullet);
				playerBullets = 0;
			}
			
			// Clean up if game is over
			if(gameOver){
				removeEventListener(Event.ENTER_FRAME, onUpdate);
				bulletDelayTimer.removeEventListener(TimerEvent.TIMER, bulletDelay);
				
				// Remove screens
				if(!MOBILE){
					removeChild(_playerLayer);
				}else{
					removeChild(_playerLayerMobile);
				}
				
				removeChild(_hudLayer);
				removeChild(moonSurface);
				
				// Go to score screen
				var playerScore:int = _hudLayer.score;
				(parent as Document).gotoScoreScreen(playerScore);
			}
		}
		
		/*
		 * Increases the number of enemies and their difficulty as
		 * well as clears and populates the screen for the next level
		*/
		private function nextLevel():void{
			// Increase level/enemy numbers
			waveNum++;
			if(levelNum < 5){
				levelNum++;
			}
			
			// Update HUD
			_hudLayer.levelText = waveNum;
			
			// Increases enemy speed
			if(enemyDiff < 15){
				enemyDiff++;
			}
			
			// Clear Screen
			clearScreen();
			
			// Populate screen
			populateScreen();
		}
		
		/*
		 * Adds a bullet to the screen either from an enemy
		 * or a player if certain conditions are met
		*/
		public function addBullet(coordX:Number, coordY:Number, fromPlayer:Boolean, bulletDir:Boolean):void{
			var shouldAddBullet:Boolean = true;
			
			// Player can only have 3 bullets on the screen at once
			// This simulates a reload delay
			if(fromPlayer){
				if(playerBullets >= 3){
					shouldAddBullet = false;
				}else{
					playerBullets++;
				}
			}else{
				if(bulletArr.length - playerBullets >= 3){
					shouldAddBullet = false;
				}
			}
			
			if(shouldAddBullet){
				var bullet:Bullet = new Bullet(coordX, coordY, fromPlayer, bulletDir);
				bulletArr.push(bullet);
				addChild(bullet);				
			}
		}

		/*
		 * Helper method to simulate bullet delay
		*/
		private function bulletDelay(e:Event):void{
			if(playerBullets > 0){
				playerBullets--;
			}
		}
		
		/*
		 * Checks if the player has enough points for a bomb
		 * the required score for a bomb doubles each time 
		 * a bomb is obtained.
		*/
		private function checkForPowerUp(){
			// Check if player has bomb access
			if(_hudLayer.score >= requiredBombScore){
				_playerLayer.alterBombNum(true);
				_hudLayer.bombText = "Bombs: " + _playerLayer.bombNum;
				requiredBombScore *= 2;
			}
		}
		
		/*
		 * Deploys a bomb, clearing the screen of all enemies
		 * and tokens and awards the player points for each
		 * bomb and enemy
		*/
		public function deployBomb(){
			// Play sound
			var channel:SoundChannel = bomb.play();
			
			// Lower volume
			var soundTrans:SoundTransform = channel.soundTransform;
			soundTrans.volume = .2;
			channel.soundTransform = soundTrans;
			
			_playerLayer.alterBombNum(false);
			_hudLayer.bombText = "Bombs: " + _playerLayer.bombNum;
			
			// Receive points for each enemy
			for each(var enemy:Enemy in enemyArr){
				// Remove enemy
				var enemyIndex:int = enemyArr.indexOf(enemy);
				enemyArr.splice(enemyIndex, 1);
				enemy.isAlive = false;
				removeChild(enemy);
				
				// Update score
				if(enemy.getType == "Microsoft"){
					_hudLayer.alterScore((Math.random() * 60), true);
				}else{
					_hudLayer.alterScore((Math.random() * 20), true);
				}
			}
			
			// Receieve points for each token
			for each(var token:Token in tokenArr){
				if(token.isPoint){
					_hudLayer.alterScore(token.getValue, true);
				}
				
				var tokenIndex:int = tokenArr.indexOf(token);
				tokenArr.splice(tokenIndex, 1);
				removeChild(token);
			}
			nextLevel(); // go to next level
		}
		
		/*
		 * Main game loop, accounts for player and enemy movements,
		 * player-bullet-enemy-token-screen interactions
		*/
		private function onUpdate(e:Event):void{
			if(!MOBILE){
				_playerLayer.pollKeyboard();
			}
			
			// Player dies from flying into outer space
			if(_currentPlayer.y <= -30){
				_currentPlayer.respawn();
				_hudLayer.alterLives(false);
			}
			
			// Updates enemies
			for each(var enemy:Enemy in enemyArr){
				// Handles enemy-bullet interactions
				for each(var bullet:Bullet in bulletArr){
					if(enemy.hitTestObject(bullet) && bullet.isFromPlayer){
						// Remove enemy
						var enemyIndex:int = enemyArr.indexOf(enemy);
						enemyArr.splice(enemyIndex, 1);
						enemy.isAlive = false;
						removeChild(enemy);
						
						// Spawn little enemies if Microsoft
						if(!enemy.isChildEnemy && enemy.getType == "Microsoft"){
							spawnLittleEnemies(enemy.x, enemy.y);
						}
						
						// Remove bullet
						var bulletIndex:int = bulletArr.indexOf(bullet);
						bulletArr.splice(bulletIndex, 1);
						bullet.isAlive = false;
						removeChild(bullet);
						
						// Update score
						if(enemy.getType == "Microsoft"){
							_hudLayer.alterScore((Math.random() * 60), true);
						}else{
							_hudLayer.alterScore((Math.random() * 20), true);
						}
						
						// Check for bomb power up
						checkForPowerUp();
						
						break;
					}
				}
				
				// If enemy has not been hit by bullets
				if(enemy.isAlive){
					// Handles enemy-player interactions
					if(enemy.hitTestObject(_currentPlayer)){		
						// Player dies from collision with enemy
						_hudLayer.alterLives(false);
						_currentPlayer.respawn();
						
						// Remove enemy
						enemyIndex = enemyArr.indexOf(enemy);
						enemyArr.splice(enemyIndex, 1);
						enemy.isAlive = false;
						removeChild(enemy);
						
						// Spawn little enemies if Microsoft
						if(!enemy.isChildEnemy && enemy.getType == "Microsoft"){
							spawnLittleEnemies(enemy.x, enemy.y);
						}
					}
				}
				
				// If enemy has not collided with the player
				if(enemy.isAlive){
					// Move enemy
					for(var i:int = 0; i < enemyDiff; i++){
						enemy.moveEnemy(_currentPlayer.x, _currentPlayer.y);
					}
				}
			}
			
			// Handle bullet-screen-player intereactions
			for each(var bullet:Bullet in bulletArr){
				if(bullet.x > (stage.stageWidth + 350) || bullet.x < -350 
				   || bullet.y < -350 || bullet.y > (stage.stageHeight + 350)){
					bulletIndex = bulletArr.indexOf(bullet);
					bulletArr.splice(bulletIndex, 1);
					bullet.isAlive = false;
					removeChild(bullet);
				}
				
				if(bullet.hitTestObject(_currentPlayer) && !bullet.isFromPlayer){
					bulletIndex = bulletArr.indexOf(bullet);
					bulletArr.splice(bulletIndex, 1);
					bullet.isAlive = false;
					removeChild(bullet);
				
					// Player dies by enemy bullet
					_currentPlayer.respawn();
					_hudLayer.alterLives(false);
				}
			}
			
			// Handle player-token interactions
			for each(var token:Token in tokenArr){
				if(_currentPlayer.hitTestObject(token)){
					// Handle point/oxygen token
					if(token.isPoint){
						_hudLayer.alterScore(token.getValue, true);
						checkForPowerUp();
					}else{
						_currentPlayer.addOxygen(token.getValue);
						_hudLayer.updateOxygenBar(_currentPlayer.oxygenAmount);
					}
					
					var tokenIndex:int = tokenArr.indexOf(token);
					tokenArr.splice(tokenIndex, 1);
					removeChild(token);
				}
			}
			
			// Decrease oxygen supply
			_currentPlayer.useOxygen();
			_hudLayer.updateOxygenBar(_currentPlayer.oxygenAmount);
			
			// Player dies from oxygen depletion
			if(!_currentPlayer.isAlive){
				_currentPlayer.respawn();
				_hudLayer.alterLives(false);
			}
			
			// Game over check
			if(_hudLayer.getLives <= 0){
				gameOver = true;
				clearScreen();
			}else{
				if(enemyArr.length == 0){
					_currentPlayer.respawn();
					nextLevel();
				}
			}
		}
	}
}