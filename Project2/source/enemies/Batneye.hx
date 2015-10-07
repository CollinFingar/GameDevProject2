package enemies;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class Batneye extends FlxSprite
{
    public static inline var MOVE_SPEED:Int =  200;
    var parent:PlayState;
	var facingLeft:Bool = true;
	var goingUp:Bool = true;
	public var healthRemaining:Int = 2;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
        makeGraphic(120, 70, FlxColor.CORAL);
		
		
        drag.set(MOVE_SPEED * 3, MOVE_SPEED * 3);
        maxVelocity.set(RUN_SPEED * 1, RUN_SPEED * 3);
		
        parent = Parent;
		var maxHeight = X +600;
		
		//scale.set(.5, .5);
        //setSize(width / 4, height / 3);
		//offset.set(width*1.5, height);
        //updateHitbox();
    }
    
    public override function update():Void {
        acceleration.x = 0;
		
		if(this.parent.player.x < this.x){
			facingLeft = true;
		} else {
			facingLeft = false;
		}
		if(goingUp){
			acceleration.y = drag.y;
			if(
		} else {
			//acceleration.x = -drag.x;
		//}
		
		
        super.update();
    }
    
    
}
