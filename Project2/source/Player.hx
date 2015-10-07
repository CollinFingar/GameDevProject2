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
	public static inline var JUMP_MIN:Int = 1500;
	public static inline var JUMP_MAX:Int = 2000;
	public static inline var JUMP_FRAMES:Int = 10;
	var jumpAmountMax:Int;
	
    var parent:PlayState;
    
    var playerJumping:Bool = false;
	var playerRunning:Bool = true;
	var facingLeft:Bool = true;
	
	// variable jump
	var jumpCountDown:Int;
	var jumpVel:Float;
	var jumpAdjust:Float;
	var jumpIncrease:Float;
	var jumpAscend:Bool;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
		
        drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
        maxVelocity.set(RUN_SPEED * 2, RUN_SPEED * 6);
        acceleration.y = 3000;
		
		jumpCountDown = 0;
		jumpVel = 0;
		jumpIncrease = cast( JUMP_MAX - JUMP_MIN, Float ) / cast(JUMP_FRAMES, Float);
		
        parent = Parent;
		
		setIdleAnimation();
    }
    
    public override function update():Void {
		jumpAscend = ( velocity.y < 0 );
		
        acceleration.x = 0;
        if (FlxG.keys.anyPressed(["LEFT", "A"])) {
			facingLeft = true;
            acceleration.x = -drag.x;
            flipX = false;
        }
        if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
			facingLeft = false;
            acceleration.x = drag.x;
            flipX = true;
        }
        if (FlxG.keys.anyPressed(["UP", "W"])) {
			
			if ( playerJumping ) {
				jumpMoar();
			} else {
				jumpStart();
			}
			
        }
		
		if(FlxG.keys.anyJustPressed(["X"])){
			shootCrossbow();
		}
		
		//Set which animation to show
		if ( velocity.y <= 0 && playerJumping ){
			
			
		} else if ( velocity.y > 0 && playerJumping ){
			
			
		} else if ( velocity.x > 0 || velocity.x < 0 ) {
			
			setRunAnimation();
			
        } else {
		
            setIdleAnimation();
			
		}
		
		
        super.update();
    }
    
    public function jumpReset():Void {
		if ( velocity.y == 0 ) {
			if ( jumpAscend ) { // hit her head
				jumpCountDown = JUMP_FRAMES;
			} else { // else
				playerJumping = false;
			}
		}
    }
	public function jumpMoar():Void {
		if ( jumpCountDown < JUMP_FRAMES ) {
			jumpVel += jumpIncrease * cast(jumpCountDown,Float)/cast(JUMP_FRAMES,Float) * jumpAdjust;
			velocity.y = -jumpVel;
			jumpCountDown ++ ;
		}
	}
	public function jumpStart():Void {
		if (!playerJumping && velocity.y == 0) {
			
			/* TEST CODE BEGIN */
			parent.hud.heal( 1 );
			/* TEST CODE END */
			
			jumpAdjust = 0.5 + Math.sqrt( Math.abs( cast(velocity.x,Float) ) ) / 100.0;
			jumpVel = cast(JUMP_MIN, Float) * jumpAdjust;
			jumpCountDown = 0;
			velocity.y = -jumpVel;
			playerJumping = true;
		}
	}
	
	public function shootCrossbow():Void {
		if (this.parent.bolts.length < 3) {
			if(facingLeft){
				var bolt:Bolt = new Bolt(this.x - width/4, this.y + height/2, -1, this.parent);
				this.parent.addBolt(bolt);
			} else {
				var bolt:Bolt = new Bolt(this.x + 3*width/4, this.y + height/2, 1, this.parent);
				this.parent.addBolt(bolt);
			}
		}
	}
	override public function destroy():Void {
		super.destroy();
	}
	
	public function setRunAnimation():Void {
		if ( !playerRunning && !playerJumping ) {
			
			loadGraphic("assets/images/damsel/princess_run1_307x343_18fps_strip12.png", true, 307, 343);
			
			animation.add( "run",  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 12, true);
			animation.play("run", false);
			
			playerRunning = true;
			setGoodHitbox();
			
		}
		
	}
	public function setIdleAnimation():Void {
		if ( playerRunning && !playerJumping ) {
			
			loadGraphic("assets/images/damsel/princess_blink1_307x343_8fps_strip8.png", true, 307, 343);
			
			animation.add( "idle", [0, 1, 2, 3, 4, 5, 6, 7], 8, true);
			animation.play("idle", false);
			
			playerRunning = false;
			setGoodHitbox();
			
		}
		
	}
	public function setGoodHitbox():Void {
		scale.set(.5, .5);
        setSize(width / 4, height / 3);
		offset.set(width*1.5, height);
	}
    
}
