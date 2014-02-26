package code{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/*
	 * Steven Shaw
	 * Project 2
	 * Bullet class
	 *	Represents a bullet in the game.
	 */
	public class Bullet extends MovieClip{
		private var _isAlive:Boolean = true;
		private var bulletSpeed:int = 10;
		private var moveBulletTimer:Timer;
		private var fromPlayer:Boolean;
		private var moveForward:Boolean;
		private var direct:String;
		private var gunShot:GunShot = new GunShot();
		
		/*
		* Constructs a bullet at a certain x and y coordinates
		* from either an enemy or a player in a certain direction
		*/
		public function Bullet(coordX:Number, coordY:Number, fromPlayer:Boolean, moveForward:Boolean){
			x = coordX;
			y = coordY;
			
			this.fromPlayer = fromPlayer;
			this.moveForward = moveForward;
			
			// Play sound
			var channel:SoundChannel = gunShot.play();
			
			// Lower volume
			var soundTrans:SoundTransform = channel.soundTransform;
			soundTrans.volume = .05;
			channel.soundTransform = soundTrans;
			
			// Enemies shoot in all directions
			if(!fromPlayer){
				var num:Number = Math.random();
				if(num <= 0.25){
					direct = "north";
					y -= 75;
					rotation = 90;
				}else if(num > 0.25 && num <= 0.50) {
					direct = "south";
					y += 50;
					rotation = 270;
				}else if(num > 0.50 && num <= 0.75){
					direct = "west";
					x -= 50;
				}else{
					direct = "east";
					x += 50;
				}
				
				gotoAndStop("enemyBullet");
			}else{
				// Players only shoot in the
				// left and right directions
				if(moveForward)
					x += 75;
				else
					x -= 100;
				gotoAndStop("playerBullet");
			}
			
			// Handles bullet movement
			moveBulletTimer = new Timer(.500, 0);
			moveBulletTimer.addEventListener(TimerEvent.TIMER, moveBullet);
			moveBulletTimer.start();
		}
		
		/*
		* Returns if the bullet is from the player or not
		*/
		public function get isFromPlayer():Boolean{ return fromPlayer; }
		
		/*
		* Sets the isAlive status of the bullet
		*/
		public function set isAlive(bulletStatus:Boolean):void{ _isAlive = bulletStatus;}
		
		/*
		* Returns if the bullet is alive or not
		*/
		public function get isBulletAlive():Boolean{ return _isAlive; }
		
		/*
		* Moves the bullet in the correct direction
		*/
		private function moveBullet(e:Event):void{
			if(fromPlayer){
				if(moveForward)
					x += bulletSpeed;
				else
					x -= bulletSpeed;
			}else{
				if(direct == "north"){
					y -= bulletSpeed;
				}else if(direct == "south"){
					y += bulletSpeed;
				}else if(direct == "west"){
					x -= bulletSpeed;
				}else{
					x += bulletSpeed;
				}
			}
			
			// Remove EventListener if bullet is dead
			if(!_isAlive){
				moveBulletTimer.removeEventListener(TimerEvent.TIMER, moveBullet)
			}
		}
	}
}