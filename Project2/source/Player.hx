package;

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
class Player extends FlxSprite
{
    public static inline var RUN_SPEED:Int =  200;
    var parent:PlayState;
    
    var playerJumping:Bool = false;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
        //makeGraphic(80, 120, FlxColor.CRIMSON);
        loadGraphic("assets/images/damsel/princess_blink1_307x343_8fps_strip8.png", true, 307, 343);
        //animation.add("walk", [4, 5, 6, 7], 12, true);
        animation.add("idle", [0,1,2,3,4,5,6,7], 8, true);
        drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
        maxVelocity.set(RUN_SPEED * 2, RUN_SPEED * 6);
        acceleration.y = 1500;
        parent = Parent;
		scale.set(.5, .5);
        setSize(width / 4, height / 3);
		offset.set(width*1.5, height);
        //updateHitbox();
    }
    
    public override function update():Void {
        acceleration.x = 0;
        if (FlxG.keys.anyPressed(["LEFT", "A"])) {
            acceleration.x = -drag.x;
            flipX = false;
        }
        if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
            acceleration.x = drag.x;
            flipX = true;
        }
        if(FlxG.keys.anyJustPressed(["SPACE"])){
            if(!playerJumping && velocity.y == 0){
                velocity.y = -1000;
                //animation.play('jump-up');
                playerJumping = true;
            }
        }
        if (velocity.x > 0 || velocity.x < 0) {
			if(velocity.x > 0){
				//makeGraphic(80, 120, FlxColor.GREEN);
			} else {
				//makeGraphic(80, 120, FlxColor.YELLOW);
			}
            //animation.play("walk");
        }
        else {
			//makeGraphic(80, 120, FlxColor.CRIMSON);
            animation.play("idle");
			
			//offset.set(width/2, height/2 + 10);
        }
		
		if(velocity.y <= 0 && playerJumping){
			//makeGraphic(80, 120, FlxColor.WHITE);
		} else if(velocity.y > 0 && playerJumping){
			//makeGraphic(80, 120, FlxColor.BLACK);
		}
        super.update();
    }
    
    public function jumpReset():Void{
        if(velocity.y == 0){
            playerJumping = false;
        }
    }
    
}
