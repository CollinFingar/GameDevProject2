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
    public static inline var MOVE_SPEED:Int =  70;
    var parent:PlayState;
	var facingLeft:Bool = true;
	public var goingUp:Bool = true;
	public var healthRemaining:Int = 2;
	
	var maxHeight:Float;
	var minHeight:Float;
	var shootRate:Int;
	var shootIndex:Int;
	
	var changed:Bool = false;
    
    public function new(X:Float=0, Y:Float=0, SR:Int = 70, Parent:PlayState) 
    {
        super(X, Y);
        //makeGraphic(120, 70, FlxColor.CORAL);
		
		
        drag.set(MOVE_SPEED * 3, MOVE_SPEED * 3);
        maxVelocity.set(MOVE_SPEED * 1, MOVE_SPEED * 3);
		
        parent = Parent;
		maxHeight = Y +300;
		minHeight = Y;
		shootRate = SR;
		shootIndex = 0;
		
		
		loadGraphic("assets/images/enemies/bat_idle1_307x266_14fps_strip5.png", true, 307, 266);
		animation.add("idle", [0, 1, 2, 3, 4], 14, true);
		animation.play("idle", false);
		
		scale.set(.75, .75);
        setSize(width / 2, height / 1.75);
		offset.set(width/2.75, height/3);
		
		//scale.set(.5, .5);
        //setSize(width / 4, height / 3);
		//offset.set(width*1.5, height);
        //updateHitbox();
    }
    
    public override function update():Void {
        velocity.y = 0;
		
		if (this.parent.player.x < this.x) {
			flipX = false;	
			facingLeft = true;
		} else {
			flipX = true;
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
		
		shootIndex += 1;
		if(shootIndex % shootRate == 0){
			if(changed){
				changed = !changed;
				//makeGraphic(120, 70, FlxColor.CORAL);
				shoot();
			} else {
				changed = !changed;
				//makeGraphic(120, 70, FlxColor.FOREST_GREEN);
				shoot();
			}
		}
		
		
        super.update();
    }
	
	public function shoot():Void{
		if(facingLeft){
				var shot:Batshot = new Batshot(this.x - width/4, this.y + height/2, -1, this.parent);
				this.parent.batShots.push(shot);
				this.parent.add(shot);
			} else {
				var shot:Batshot = new Batshot(this.x + 3*width/4, this.y + height/2, 1, this.parent);
				this.parent.batShots.push(shot);
				this.parent.add(shot);

			}
		}
	
    
    
}
