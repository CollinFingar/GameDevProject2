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
	static inline var ANIM_RUN 		= 4;
	static inline var ANIM_SWORD 	= 5;

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
	["run", "assets/images/damsel/princess_run1_307x343_18fps_strip12.png", 	 307, 343, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 	true,  11 ],
	["sword", "assets/images/damsel/princess_attack1_307x343_20fps_strip7.png",	 307, 343, [0, 1, 2, 3, 4, 5, 6], 					false, 20  ] ];
	
    public static inline var RUN_SPEED:Int 		= 200;
	public static inline var JUMP_MIN:Int 		= 1500;
	public static inline var JUMP_MAX:Int 		= 3000;
	public static inline var JUMP_FRAMES:Int 	= 10;
	
	var jumpAmountMax:Int;
	var parentComponent:FlxPoint;
	
    var parent:PlayState;
    var state:Int;
    
	var shooting:Float;
	var swinging:Float;
	var shootMax:Float;
	var swingMax:Float;
	
	var retainParent:Int = 0;
    var playerJumping:Bool = false;
	var playerJumpStart:Bool = false;
	var facingLeft:Bool = true;
	
	var ctrlLeft:Bool = false;
	var ctrlRight:Bool = false;
	var ctrlUp:Bool = false;
	var ctrlX:Bool = false;
	var ctrlZ:Bool = false;
	
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
		jumpIncrease = cast( JUMP_MAX - JUMP_MIN, Float ) / cast(JUMP_FRAMES, Float);
		
		shooting = -1;
		swinging = -1;
		
		shootMax = cast( ANIMATIONS[ANIM_SHOOT][ANIMI_FRAMERATE], Float ) / 60.0;
		swingMax = cast( ANIMATIONS[ANIM_SWORD][ANIMI_FRAMERATE], Float ) / 60.0;
		
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
		ctrlZ = FlxG.keys.anyPressed(["Z"]);
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
		
		if ( shooting != -1 ) {
			shooting += FlxG.elapsed;
		}
		if ( swinging != -1 ) {
			swinging += FlxG.elapsed;
		}
		
		trace( shooting, swinging );
		
		if ( ctrlX )
			shootCrossbow();
		if ( ctrlZ )
			swingSword();
	}
	public function updateAnimation() {
		while ( true ) switch ( state ) {
			case ANIM_IDLE:
				
				if ( shooting != -1 )
					setAnimation( ANIM_SHOOT );
					
				else if ( swinging != -1 )
					setAnimation( ANIM_SWORD );
				
				else if ( velocity.y > 0 && master == null ) 
					setAnimation( ANIM_FALL );
					
				else if ( velocity.y < 0 ) 
					setAnimation( ANIM_JUMP );
					
				else if ( ctrlLeft || ctrlRight )
					setAnimation( ANIM_RUN );
					
				else
					return;
					
			case ANIM_FALL:
				
				if ( shooting != -1 )
					setAnimation( ANIM_SHOOT );
					
				else if ( swinging != -1 )
					setAnimation( ANIM_SWORD );
				
				else if ( velocity.y == 0 )
					setAnimation( ANIM_IDLE );
					
				else if ( velocity.y < 0 )
					setAnimation( ANIM_JUMP );
					
				else
					return;
					
			case ANIM_RUN:
				
				if ( shooting != -1 )
					setAnimation( ANIM_SHOOT );
					
				else if ( swinging != -1 )
					setAnimation( ANIM_SWORD );
				
				else if ( !(ctrlLeft || ctrlRight) )
					setAnimation( ANIM_IDLE );
					
				else if ( velocity.y < 0 )
					setAnimation( ANIM_JUMP );
					
				else if ( velocity.y > 0 && master == null )
					setAnimation( ANIM_FALL );
					
				else
					return;
					
			case ANIM_JUMP:
				if ( shooting != -1 )
					setAnimation( ANIM_SHOOT );
					
				else if ( swinging != -1 )
					setAnimation( ANIM_SWORD );
				
				else if ( velocity.y > 0 && master == null )
					setAnimation( ANIM_FALL );
					
				else if ( velocity.y == 0 && master != null )
					setAnimation( ANIM_IDLE );
					
				else
					return;
					
			case ANIM_SHOOT:
				if ( animation.finished || shooting >= shootMax ) {
					shooting = -1;
					if ( velocity.y > 0 && master == null ) 
						setAnimation( ANIM_FALL );
						
					else if ( velocity.y < 0 ) 
						setAnimation( ANIM_JUMP );
						
					else if ( ctrlLeft || ctrlRight )
						setAnimation( ANIM_RUN );
						
					else
						setAnimation( ANIM_IDLE );
				}
				else
					return;
					
			case ANIM_SWORD:
				if ( animation.finished || swinging >= swingMax ) {
					swinging = -1;
					if ( velocity.y > 0 && master == null ) 
						setAnimation( ANIM_FALL );
						
					else if ( velocity.y < 0 ) 
						setAnimation( ANIM_JUMP );
						
					else if ( ctrlLeft || ctrlRight )
						setAnimation( ANIM_RUN );
						
					else
						setAnimation( ANIM_IDLE );
				}
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
		if ( shooting == -1 && swinging == -1 && this.parent.bolts.length < 2) {
			shooting = 0;
			if(facingLeft){
				var bolt:Bolt = new Bolt(this.x - width/4, this.y + height/2, -1, this.parent);
				this.parent.addBolt(bolt);
			} else {
				var bolt:Bolt = new Bolt(this.x + 3*width/4, this.y + height/2, 1, this.parent);
				this.parent.addBolt(bolt);
			}
		}
	}
	
	public function swingSword():Void {
		if ( swinging != -1 || shooting != -1 )
			return;
		
		swinging = 0;
		
		var swingArea:FlxSprite = new FlxSprite(this.x, this.y);
		if (facingLeft) {
			swingArea.x = this.x - this.width;
			swingArea.width = this.width;
			swingArea.height = this.height;
		} else {
			swingArea.x = this.x + this.width;
			swingArea.width = this.width;
			swingArea.height = this.height;
		}
		
		for(i in 0...this.parent.walkers.length){
			if(FlxG.collide(this.parent.walkers[i], swingArea)){
					this.parent.walkers[i].healthRemaining -= 1;
					
					if(this.parent.walkers[i].x > this.x){
						this.parent.walkers[i].velocity.x = 1500;
					} else {
						this.parent.walkers[i].velocity.x = -1500;
					}
				
					if(this.parent.walkers[i].healthRemaining < 1){
						this.parent.remove(this.parent.walkers[i]);
						this.parent.walkers.splice(i, 1);
					}
			}
		}
		for(i in 0...this.parent.batneyes.length){
				if(FlxG.collide(this.parent.batneyes[i], swingArea)){
					this.parent.batneyes[i].healthRemaining -= 1;
					
					if(this.parent.batneyes[i].x > this.x){
						this.parent.batneyes[i].velocity.x = 1500;
					} else {
						this.parent.batneyes[i].velocity.x = -1500;
					}
					
					if(this.parent.batneyes[i].healthRemaining < 1){
						this.parent.remove(this.parent.batneyes[i]);
						this.parent.batneyes.splice(i, 1);
					}
			}
		}
		for(i in 0...this.parent.shieldGuys.length){
			if(FlxG.collide(this.parent.shieldGuys[i], swingArea)){
					this.parent.shieldGuys[i].healthRemaining -= 1;
					if(this.parent.shieldGuys[i].shieldBroken == false){
						this.parent.shieldGuys[i].shieldBroken = true;
					}
					if(this.parent.shieldGuys[i].x > this.x){
						this.parent.shieldGuys[i].velocity.x = 1500;
					} else {
						this.parent.shieldGuys[i].velocity.x = -1500;
					}
					
					if(this.parent.shieldGuys[i].healthRemaining < 1){
						this.parent.remove(this.parent.shieldGuys[i]);
						this.parent.shieldGuys.splice(i, 1);
					}
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
