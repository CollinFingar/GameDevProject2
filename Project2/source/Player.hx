package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import platforms.PlatformTiles;

class Player extends MoveBase
{
	static inline var ANIM_IDLE 	= 0;
	static inline var ANIM_SHOOT 	= 1;
	static inline var ANIM_FALL 	= 2;
	static inline var ANIM_JUMP 	= 3;
	static inline var ANIM_RUN 	= 4;

	static inline var ANIMI_NAME = 0;
	static inline var ANIMI_FNAME = 1;
	static inline var ANIMI_W = 2;
	static inline var ANIMI_H = 3;
	static inline var ANIMI_FRAMES = 4;
	static inline var ANIMI_LOOP = 5;
	static inline var ANIMI_FRAMERATE = 6;

	private static var ANIMATIONS:Array<Dynamic> = [
	["idle", "assets/images/damsel/princess_blink1_307x343_8fps_strip8.png", 	 307, 343, [0, 1, 2, 3, 4, 5, 6, 7],				true,  14 ],
	["shoot", "assets/images/damsel/princess_shoot1_307x343_16fps_strip5.png",   307, 343, [0, 1, 2, 3, 4], 						false, 14 ],
	["fall", "assets/images/damsel/princess_fallloop1_307x343_20fps_strip4.png", 307, 343, [0, 1, 2, 3], 							true,  14 ],
	["jump", "assets/images/damsel/princess_jump1_307x343_12fps_strip3.png", 	 307, 343, [0, 1, 2],								false, 24 ],
	["run", "assets/images/damsel/princess_run1_307x343_18fps_strip12.png", 	 307, 343, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 	true,  11 ] ];
	
    public static inline var RUN_SPEED:Int 		= 200;
	public static inline var JUMP_MIN:Int 		= 1500;
	public static inline var JUMP_MAX:Int 		= 3000;
	public static inline var JUMP_FRAMES:Int 	= 10;
	
	var jumpAmountMax:Int;
	var parentComponent:FlxPoint;
	
    var parent:PlayState;
    var state:Int;
	
	var justShotCrossbow:Float;
	
	var retainParent:Int = 0;
    var playerJumping:Bool = false;
	var playerJumpStart:Bool = false;
	var facingLeft:Bool = true;
	
	var ctrlLeft:Bool = false;
	var ctrlRight:Bool = false;
	var ctrlUp:Bool = false;
	var ctrlX:Bool = false;
	
	// variable jump
	var jumpCountDown:Int;	// Timer for when more jumping is allowed
	var jumpVel:Float;		// Floating point representation of velocity.y
	var jumpAdjust:Float;	// Amount of jump based on horizontal motion
	var jumpIncrease:Float;	// Amount of extra vertical velocity per frame
	
	var idtmr:Int;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
		
		// FlxSprite values
        drag.set(RUN_SPEED * 8, RUN_SPEED * 8);
        maxVelocity.set(RUN_SPEED * 2, RUN_SPEED * 6);
		jumpCountDown = 0;
		jumpVel = 0;
		justShotCrossbow = 0;
		jumpIncrease = cast( JUMP_MAX - JUMP_MIN, Float ) / cast(JUMP_FRAMES, Float);
		
        parent = Parent;
		state = ANIM_IDLE;
		idtmr = 0;
    }
    
    public override function update():Void {
		handleInput();
		moveCharacter();
		updateAnimation();
		
        super.update();
		
		idtmr ++ ;
    }
	public function late_update():Void {
		if ( retainParent == 0 )
			assignBase();
		else
			retainParent -- ;
	}
	public function handleInput() {
		ctrlLeft = FlxG.keys.anyPressed(["LEFT", "A"]);
		ctrlRight = FlxG.keys.anyPressed(["RIGHT", "D"]);
		ctrlUp = FlxG.keys.anyPressed(["UP", "W", "SPACE"]);
		ctrlX = FlxG.keys.anyPressed(["X"]);
	}
	public function moveCharacter() {
		acceleration.x = 0;
		if ( master == null && !(jumpCountDown < JUMP_FRAMES ) )
			acceleration.y = 3200;
		
		if ( ctrlLeft ) {
			facingLeft = true;
			acceleration.x = -drag.x;
			flipX = false;
		}
		if ( ctrlRight ) {
			facingLeft = false;
			acceleration.x = drag.x;
			flipX = true;
		}
		if ( ctrlUp ) {
			if ( playerJumping ) {
				jumpMoar();
			} else {
				jumpStart();
			}
		} else {
			jumpCountDown = JUMP_FRAMES;
		}
		
		if ( justShotCrossbow > 0 ) {
			justShotCrossbow -= FlxG.elapsed;
			if ( justShotCrossbow < 0 )
				justShotCrossbow = 0;
		}
		trace( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+justShotCrossbow );
		if ( ctrlX )
			shootCrossbow();
	}
	public function updateAnimation() {
		while ( true ) switch ( state ) {
			case ANIM_IDLE:
				
				if ( velocity.y > 0 && master == null ) 
					setAnimation( ANIM_FALL );
					
				else if ( velocity.y < 0 ) 
					setAnimation( ANIM_JUMP );
					
				else if ( ctrlLeft || ctrlRight )
					setAnimation( ANIM_RUN );
					
				else if ( ctrlX && ( state == ANIM_IDLE ) )
					setAnimation( ANIM_SHOOT );
					
				else
					return;
					
			case ANIM_FALL:
				
				if ( velocity.y == 0 )
					setAnimation( ANIM_IDLE );
					
				else if ( velocity.y < 0 )
					setAnimation( ANIM_JUMP );
					
				else
					return;
					
			case ANIM_RUN:
				
				if ( !(ctrlLeft || ctrlRight) )
					setAnimation( ANIM_IDLE );
					
				else if ( velocity.y < 0 )
					setAnimation( ANIM_JUMP );
					
				else if ( velocity.y > 0 && master == null )
					setAnimation( ANIM_FALL );
					
				else
					return;
					
			case ANIM_SHOOT:
				if ( ctrlLeft || ctrlRight )
					setAnimation( ANIM_RUN );
					
				else if ( velocity.y < 0 )
					setAnimation( ANIM_JUMP );
					
				else if ( velocity.y > 0 && master == null )
					setAnimation( ANIM_FALL );
					
				else if ( animation.finished )
					setAnimation( ANIM_IDLE );
					
				else
					return;
					
			case ANIM_JUMP:
				if ( velocity.y > 0 && master == null )
					setAnimation( ANIM_FALL );
					
				else if ( velocity.y == 0 && master != null )
					setAnimation( ANIM_IDLE );
					
				else
					return;
					
			default:
				return;
		}
	}
	
	public override function shouldCollide( other:platforms.PlatformTiles ):Bool {
		return super.shouldCollide( other );
	}
	public override function collision( other:platforms.PlatformTiles, xsep:Bool, ysep:Bool ):Void {
		if ( ysep ) {
			if ( playerJumping ) {
				if ( ( touching & FlxObject.UP ) != 0 ) {
					jumpCountDown = JUMP_FRAMES;
				} else {
					playerJumping = false;
					retainParent = 4;
					assignBase( other );
				}
			} else if ( ( touching & FlxObject.DOWN ) != 0 ) {
				retainParent = 4;
				assignBase( other );
			}
		}
		super.collision( other, xsep, ysep );
	}
    
	public function jumpMoar():Void {
		if ( jumpCountDown < JUMP_FRAMES ) {
			var t:Float = -jumpIncrease * cast(jumpCountDown, Float) / cast(JUMP_FRAMES, Float) * jumpAdjust;
			velocity.y += t;
			jumpCountDown ++ ;
		}
	}
	public function jumpStart():Void {
		if (!playerJumping && velocity.y == 0) {
			
			jumpAdjust = 0.5 + Math.sqrt( Math.abs( cast(velocity.x,Float) ) ) / 100.0;
			jumpVel = cast(JUMP_MIN, Float) * jumpAdjust;
			jumpCountDown = 0;
			velocity.y += -jumpVel;
			playerJumpStart = true;
			playerJumping = true;
			assignBase();
			
		}
	}
	
	public function shootCrossbow():Void {
		if ( justShotCrossbow == 0 && this.parent.bolts.length < 2) {
			justShotCrossbow = cast( ANIMATIONS[ANIM_SHOOT][ANIMI_FRAMERATE], Float ) / 30.0;
			trace( ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "+justShotCrossbow );
			if(facingLeft){
				var bolt:Bolt = new Bolt(this.x - width/4, this.y + height/2, -1, this.parent);
				this.parent.addBolt(bolt);
			} else {
				var bolt:Bolt = new Bolt(this.x + 3*width/4, this.y + height/2, 1, this.parent);
				this.parent.addBolt(bolt);
			}
		}
	}
	
	public function setAnimation( st:Int ) {
		if ( state != st ) {
			state = st;
			loadGraphic( ANIMATIONS[st][ANIMI_FNAME],
						 true,
						 ANIMATIONS[st][ANIMI_W],
						 ANIMATIONS[st][ANIMI_H] );
						 
			animation.add( ANIMATIONS[st][ANIMI_NAME],
						   ANIMATIONS[st][ANIMI_FRAMES], 
						   ANIMATIONS[st][ANIMI_FRAMERATE], 
						   ANIMATIONS[st][ANIMI_LOOP] );
						   
			animation.play( ANIMATIONS[st][ANIMI_NAME],
							false );
							
			scale.set(.5, .5);
			setSize(width / 4, height / 3);
			offset.set(width*1.5, height);
		}
	}
}
