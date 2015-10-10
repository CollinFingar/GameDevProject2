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
class Walker extends FlxSprite
{
    public static inline var RUN_SPEED:Int =  200;
    var parent:PlayState;
	var facingLeft:Bool = true;
	public var healthRemaining:Int = 3;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
        makeGraphic(80, 120, FlxColor.CRIMSON);
		
		
        drag.set(RUN_SPEED * 3, RUN_SPEED * 3);
        maxVelocity.set(RUN_SPEED * 1, RUN_SPEED * 3);
        acceleration.y = 3000;
        parent = Parent;
		
		//loadGraphic("assets/images/enemies/skelly_walk1_340x343_12fps_strip7.png", true, 340, 343);
		//animation.add("idle", [0, 1, 2, 3, 4, 5, 6], 12, true);
		//animation.play("idle", false);
		
		//scale.set(.75, .75);
        //setSize(width / 2, height / 1.75);
		//offset.set(width/2.75, height/3);
        //updateHitbox();
    }
    
    public override function update():Void {
        acceleration.x = 0;
		if(facingLeft && velocity.x ==0){
			facingLeft = false;
			acceleration.x = -drag.x;
			flipX = true;
		} else if(facingLeft){
			acceleration.x = drag.x;
		} else if(!facingLeft && velocity.x ==0){
			facingLeft = true;
			acceleration.x = drag.x;
			flipX = false;
		} else {
			acceleration.x = -drag.x;
		}
		
		
        super.update();
    }
    
    
}
