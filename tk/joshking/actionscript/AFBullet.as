package tk.joshking.actionscript {
	import tk.joshking.actionscript.Ship;
    import flash.display.Stage;
    import flash.display.MovieClip;
    import flash.events.Event;
 
    public class AFBullet extends MovieClip {
        private var stageRef:Stage
        private var speed:Number = 25;
        private var xVel:Number = 0; 
        private var yVel:Number = 0;
        private var rotationInRadians = 0;
 
        public function AFBullet(stageRef:Stage, X:int, Y:int, rotationInDegrees:Number):void {
            this.stageRef = stageRef;
            this.x = X;
            this.y = Y;
            this.rotation = rotationInDegrees;
        }
		
		public function loop():void {
			xVel = Math.cos(Ship.degreesToRadians(rotation)) * speed;
			yVel = Math.sin(Ship.degreesToRadians(rotation)) * speed;
			
			x += xVel;
			y += yVel;
			
			if(x > stageRef.stageWidth || x < 0 || y > stageRef.stageHeight || y < 0) {
				this.parent.removeChild(this);
			}
		}
    }
	
}
