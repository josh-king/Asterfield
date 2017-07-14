package tk.joshking.actionscript {
	import flash.display.*;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import com.senocular.utils.KeyObject;
	import flash.system.System;
	import tk.joshking.actionscript.*;
	import flash.events.KeyboardEvent;

	/**
	* A very simple asteroid game that has some funky physics along with it.
	* Uses a utility class file from senocular which contains some nice keyboard
	* functions for looping.
	*
	* Ship$created 
	*		07/03/2015
	* Ship$author 
	*		Josh King
	*/
	public class Ship extends MovieClip {
		/**
		* Implementation of a very useful key Event system
		*
		* KeyObject$author 
		*		senocular.com
		*/
		var key:KeyObject;
		// Speed multiplier variables
		var speed:Number = 0.3;
		var rotateSpeed:Number = 5;
		// Positioning variable
		var vx:Number = 0;
		var vy:Number = 0;
		// Friction variable
		var friction:Number = 0.95;
		// checks if the game has been started with user input
		static var started:Boolean = new Boolean(false);
		// Total amount of lives the player has
		static var health:Number = 3;
		var healthconst:Number = health;
		var shot:Boolean = new Boolean(false);
		// Boost variables
		static var boost:Number = 50;
		var boostAdd:Number = 0;
		var canAddBoost:Boolean = new Boolean(true);
		// Boost Number variable (For key change)
		var boostKeybind:Number = Keyboard.SHIFT;
		// Shoot Number variable (For key change)
		var shootKeybind:Number = Keyboard.SPACE;
		
		public var bulletList:Array = []; //new array for the bullets

		/**
		* Initializing the KeyObject {$see com.senocular.utils.KeyObject} for
		* full class. And for creating the ENTER_FRAME event listener.
		* Ship$created 
		*		07/03/2015
		* Ship$author 
		*		Josh King
		*/
		public function Ship():void {
			consolePrnt("Asterfield is initializing.", 2);
			
			key = new KeyObject(stage);
			consolePrnt("Initialized the 'key' variable linking to ($$com.senocular.utils.KeyObject$$).", 2);
						
			stage.addEventListener(Event.ENTER_FRAME, loop);
			consolePrnt("Added Event.ENTER_FRAME to the Event Bus ($$tk.joshking.actionscript.Ship$$).", 2);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shoot, false, 0, true);
			consolePrnt("Added KeyboardEvent.KEY_DOWN to the Event Bus ($$tk.joshking.actionscript.AFBullet$$).", 2);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			consolePrnt("Scale mode set to NO_SCALE.", 2);
			
			consolePrnt("Asterfield fully initailized.", 2);
		}
		
		/**
		* The loop function which is created on the ENTER_FRAME eventlistener.
		* Handles all of the in-game logic, most which was from the help of many
		* hours of reading.
		*
		* loop$doc
		*		http://math.about.com/od/algebraworksheets/a/radians.html
		*/
		public function loop(e:Event):void {
			// Calculates the movement of the ship
			this.calculateMovement(rotateSpeed);
			
			// Checks if the boost key is being held
			if (key.isDown(this.boostKeybind))
				this.calculateboost();
			else
				this.increastBoostMeter();
			
			// Checks if the shoot button has been pressed
			
			if(bulletList.length > 0) {
                for(var i:int = bulletList.length - 1; i >= 0; i--) {
                    bulletList[i].loop(); //call its loop() function
                }
            }
			
			// Position conversion
			x += vx;
			y += vy;
			
			// Loop the ship on the stage
			rePosition(stage.stageWidth, stage.stageHeight)
			
			// detects if the health has been changed
			detectHealthChange();
			
			if(health <= 0) {
				stop();
				consolePrnt("END GAME", 3);
			}
		}
		
		/**
		* Checks to see if the player has pressed the shoot button.
		*/
		public function shoot(e:KeyboardEvent):void {
			if(e.keyCode == this.shootKeybind) {
				var bullet:AFBullet = new AFBullet(stage, 50, 0, 0);
				bulletList.push(bullet);
				addChild(bullet);
				bullet.addEventListener(Event.REMOVED_FROM_STAGE, bulletRemoved);
			}
		}
		
		/**
		* A simple method to remove the bullet that has been rendered onto the screen.
		*/
		public function bulletRemoved(e:Event):void {
            e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, bulletRemoved);
            bulletList.splice(bulletList.indexOf(e.currentTarget), 1); 
        }
		
		/**
		* A simple utility function that detects whether there has been any change in health
		* {$see healthconst:Number} {$see lives:Number}
		*/
		private function detectHealthChange():void {
			if(healthconst > health){
				consolePrnt("Life update[decrease]: (healthConst$" + healthconst + ") : (totalHealth$" + health + ")", 1);
				healthconst =+ health;
			} else if(healthconst < health){
				consolePrnt("Life update[increase]: (healthConst$" + healthconst + ") : (totalHealth$" + health + ")", 1);
				healthconst += health;
			}
		}
		
		/**
		* Calculates the movement for the ship depending on the key that is being pressed.
		*
		* calculateMovement$i
		* 		A number that is for rotation
		*/
		private function calculateMovement(i:Number) {
			if(key.isDown(Keyboard.UP)) {
				vx += Math.cos(degreesToRadians(rotation)) * speed;
				vy += Math.sin(degreesToRadians(rotation)) * speed;
				started = new Boolean(true);
			} else {
				vy *= friction;
				vx *= friction;
			}
			
			if(key.isDown(Keyboard.RIGHT))
				rotation += i;
			else if (key.isDown(Keyboard.LEFT))
				rotation -= i;
			else if (key.isDown(Keyboard.J))
				health -= 1;
			else if (key.isDown(Keyboard.K))
				health += 1;
		}
		
		/**
		* A method that calculates what should happen to the boost once the boost button
		* {$see boostButton:Number} for a changeable variable.
		*/
		private function calculateboost() {
			if(boost > 0) {
				vy += Math.sin(degreesToRadians(rotation)) * (speed * 10);
				vx += Math.cos(degreesToRadians(rotation)) * (speed * 10);
				boost--;
				consolePrnt("Boost at " + (boost * 2) + "%", 1);
			}
		}
		
		/**
		* A method that increases the amount of total boost that is available to the ship.
		* The method checks to see if the boost has actually been depleted.
		*/
		private function increastBoostMeter() {
			if (boost < 50) {
				this.canAddBoost = new Boolean(true);
				boostAdd++;
			}
			
			if((boostAdd == 30) && (this.canAddBoost)) {
				boost += 1;
				consolePrnt("Boost percentage added!(total/" + boost * 2 + "%)", 1);
				boostAdd = 0;
			}
		}

		/**
		* Keep the ship within the bounds by resetting the x/y position whenever
		* the position is greater or less than the stage values.
		*
		* widthPos$Number
		*		The max width of the area
		* heightPos$Number		
		*		The max height of the area
		*/
		private function rePosition(widthPos:Number, heightPos:Number) {
			if (x > widthPos)
				x = 0;
			else if (x < 0)
				x = widthPos;
			 
			if (y > heightPos)
				y = 0;
			else if (y < 0)
				y = heightPos;
		}
		
		/**
		* A function that converts the input degrees into radians
		* by multiplying it by Math.PI.
		*
		* degreesToRadians$doc
		*		http://math.about.com/od/algebraworksheets/a/radians.html
		* degrees$Number
		*		The degrees that needs to be converted
		* degreesToRadians$return
		*		Converted radian
		*/
		public static function degreesToRadians(degrees:Number):Number {
			return degrees * Math.PI / 180;
		}
		
		/**
		* A method that is just a simple 'trace' call with a prefix attached to it.
		*
		* string$String
		*		The string that needs to be printed.
		*/
		public static function consolePrnt(string:String, purpose:Number):void {
			if(purpose == 1)
				return trace("[Asterfield/DEBUG]: " + string);
			if(purpose == 2)
				return trace("[Asterfield/INFO]: " + string);
			if(purpose == 3)
				return trace("[Asterfield/ERROR]: " + string);
		}
	}
	
}