package code{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.ui.*;
	import flash.sensors.Accelerometer; 
	import flash.events.AccelerometerEvent;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * PlayerLayerMobile class:
	 * 	Represents a player layer on mobile devices
	 *	
	 * NOT IMPLEMENTED
	 */
	public class PlayerLayerMobile extends Sprite{
		public var _player:Player;
		public var gameScreen:GameScreen;
		private var my_acc:Accelerometer = new Accelerometer();

		/*
		* Inits the player layer with a specific game screen
		* and creates the player
		*/
		public function PlayerLayerMobile(aGameScreen:GameScreen){
			my_acc.setRequestedUpdateInterval(50);
			gameScreen = aGameScreen;
			
			_player = new Player();
			addChild(_player);
		}
		
		/*
		* Updates the player's position with a mobile
		* device's accelerometer
		*/
		public function onAccUpdate(e:AccelerometerEvent):void{
			_player.x -= (e.accelerationX * 10);
			_player.y += (e.accelerationY * 10); 
			
			if(_player.x < 0){
				_player.x = 0; 
			}else if(_player.x > stage.stageWidth){ 
				_player.x = stage.stageWidth; 
			} 
			
			if(_player.y < 0){ 
				_player.y = 0; 
			}else if (_player.y > stage.stageHeight){
				_player.y = stage.stageHeight; 
			}
		}
	}
}