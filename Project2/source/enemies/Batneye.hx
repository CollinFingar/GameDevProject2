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
	
	var maxHeight:Float;
	var minHeight:Float;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
        makeGraphic(120, 70, FlxColor.CORAL);
		
		
        drag.set(MOVE_SPEED * 3, MOVE_SPEED * 3);
        maxVelocity.set(MOVE_SPEED * 1, MOVE_SPEED * 3);
		
        parent = Parent;
		maxHeight = Y +600;
		minHeight = Y;
		
		//scale.set(.5, .5);
        //setSize(width / 4, height / 3);
		//offset.set(width*1.5, height);
        //updateHitbox();
    }
    
    public override function update():Void {
        velocity.y = 0;
		
		if(this.parent.player.x < this.x){
			facingLeft = true;
		} else {
			facingLeft = false;
		}
		if(goingUp){
			velocity.y = drag.y;
			if(this.y > maxHeight){
				goingUp = false;
			}
		} else {
			velocity.y = -drag.y;
			if(this.y < minHeight){
				goingUp = true;
			}
		}
		
		
        super.update();
    }
    
    
}
