package tk.joshking.actionscript {
	import flash.display.*;
	import flash.text.*;
	import flash.events.Event;
	import tk.joshking.actionscript.*;
	import flash.utils.getDefinitionByName;
	import com.efnx.fps.fpsBox;
	
	public class Background extends MovieClip {
		var instructions:String = "HOW TO PLAY:\nUse the arrow keys to move" + 
		"\nUse space to fire rockets" +
		"\nYou have a total of 3 Lives" +
		"\nUse shift button to enable boost";
		var instructionsField:TextField = new TextField();
		var instructionsFormat:TextFormat = new TextFormat();

		var boostField:TextField = new TextField();
		var boostFormat:TextFormat = new TextFormat();
		
		var titleField:TextField = new TextField();
		var titleFormat:TextFormat = new TextFormat();
		
		var healthField:TextField = new TextField();
		var healthFormat:TextFormat = new TextFormat();
		
		var newX:Number = stage.width - 90;
		var heartCount:Number = 0;
		var fps:fpsBox = new fpsBox();
		
		public function Background():void {
			addEventListener(Event.ENTER_FRAME, renderObjects, false, 0, true);
			Ship.consolePrnt("Added Event.ENTER_FRAME to the Event bus (tk.joshking.actionscript.Background).", 2);

			titleFormat.size = 50;
			titleFormat.align = TextFormatAlign.CENTER;
			titleField.defaultTextFormat = titleFormat;
			
			instructionsFormat.size = 25;
 			instructionsFormat.align = TextFormatAlign.CENTER;
			instructionsField.defaultTextFormat = instructionsFormat;
			
			boostFormat.size = 20;
			boostField.defaultTextFormat = boostFormat;
			boostField.y = stage.height - 22;
			
			healthFormat.size = 20;
			healthField.defaultTextFormat = healthFormat;
		}
		
		/**
		* A render call for anything that needs to be placed on the Background.
		*/
		public function renderObjects(e:Event):void {
			if(!Ship.started) {
				this.renderTitle(true);
				this.showInstructions(true);
			} else if(Ship.started && ((e.target.contains(instructionsField)|| e.target.contains(titleField)))) {
				this.renderTitle(false);
				this.showInstructions(false);
			}
			
			if(Ship.started) {
				this.renderBoost();
				this.renderHealth();
				addChild(fps);
			}
		}
		
		/**
		* Renders the title of the game to the screen that will disappear after some kind of user input.
		* {see$titleField}
		*/
		private function renderTitle(flag:Boolean):void {
			titleField.text = "ASTERFIELD";
			titleField.textColor = 0xc00000;
			titleField.width = 310;
			titleField.x = 370;
			
			if (flag)
				addChild(titleField);
			else if (!flag)
				removeChild(titleField)
		}
		
		/**
		* Shows the Boost amount on the stage.
		* {see$boostField}
		*/
		private function renderBoost():void {
			var i:Number = Ship.boost * 2;
			boostField.text = "Boost: " + i.toString() + "% Lives: " + Ship.health;
			boostField.textColor = 0xff0000;
			boostField.width = 200;
			
			addChild(boostField);
		}
		
		/**
		* Shows the instructions that displays at the start of the game.
		* {see$instructionsField}
		*
		* showInstructions$flag
		* 		true to addchil false to removeChild.
		*/
		private function showInstructions(flag:Boolean):void {
			instructionsField.textColor = 0xffffff;
			instructionsField.width = 350;
			instructionsField.height = 300;
			instructionsField.x = 350;
			instructionsField.y = 200;
			if(flag) {
				instructionsField.text = instructions;
				addChild(instructionsField);
			} else if (!flag) {
				removeChild(instructionsField);
				Ship.consolePrnt("Removed instructions from main screen.", 1);
			}
		}
		
		/**
		* A method that renders the total amount of health for the ship. Will remove the heart if 
		* the ship's health has been changed.
		*/
		private function renderHealth():void {
			/**healthField.textColor = 0xffffff;
			healthField.width = 200;
			healthField.y = 22;
			healthField.x = 22;
			
			switch(Ship.health) {
				case 3:
					healthField.text = "[o][o][o]";
					break;
				case 2:
					healthField.text = "[o][o]";
					break;
				case 1:
					healthField.text = "[o]";
					break;
				default:
					healthField.text = "r u god"
			}

			addChild(healthField);*/
			
			for(var i:int; i < Ship.health; i++) {
				var icon:MovieClip = new Heart1();
				icon.y = stage.height - 110;
					
				if(heartCount < Ship.health) {
					if(newX > 970)
						newX = 900
					
					icon.x = (newX - 10);
								
					heartCount++;
					stage.addChildAt(icon, heartCount);
					newX += 30;
					
					Ship.consolePrnt("Added child " + stage.getChildAt(heartCount) + " {xPos$"+icon.x + "} {heartID$" + heartCount + "}", 1);
				} else if(heartCount > Ship.health) {
					heartCount--;

					stage.removeChildAt(heartCount);
						
					Ship.consolePrnt("Removed child " + stage.getChildAt(heartCount) + " {xPos$"+icon.x + "} {heartID$" + heartCount + "}", 1);
				} else {
					 //DO SOMETHING	
				}
			}
		}
	}
	
}