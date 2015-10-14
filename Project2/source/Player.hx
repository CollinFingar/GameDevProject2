package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import haxe.macro.Expr.Var;
import platforms.PlatformCollision;
import platforms.PlatformTiles;
import AnimationController;

class Player extends MoveBase implements Actor
{
	public static inline var SIG_PRINCESS_AWAKE = 0;
	public static inline var SIG_PRINCESS_ANGRY = 1;
	public static inline var SIG_PRINCESS_DONE = 2;
	
	public static inline var ANIM_IDLE 			=  0;
	public static inline var ANIM_SHOOT 		=  1;
	public static inline var ANIM_FALL 			=  2;
	public static inline var ANIM_JUMP 			=  3;
	public static inline var ANIM_RUN 			=  4;
	public static inline var ANIM_SWORD 		=  5;
	public static inline var ANIM_LAND 			=  6;
	public static inline var ANIM_AWAKEN 		=  7;
	public static inline var ANIM_HURT 			=  8;
	public static inline var ANIM_DEATH 		=  9;
	public static inline var ANIM_DEATH_LOOP 	= 10;
	public static inline var ANIM_INTRO 		= 11;
	public static inline var ANIM_ASLEEP 		= 12;
	
	public static inline var ANIMI_NAME 		= 0;
	public static inline var ANIMI_FNAME 		= 1;
	public static inline var ANIMI_W 			= 2;
	public static inline var ANIMI_H 			= 3;
	public static inline var ANIMI_FRAMES 		= 4;
	public static inline var ANIMI_LOOP 		= 5;
	public static inline var ANIMI_FRAMERATE 	= 6;

	public static var ANIMATIONS:Array<Dynamic> = [
	
		["idle", "assets/images/damsel/princess_blink1_307x343_8fps_strip8.png", 	 		307, 343, [0, 1, 2, 3, 4, 5, 6, 7],					true,  14 ],
		["shoot", "assets/images/damsel/princess_shoot1_307x343_16fps_strip5.png",   		307, 343, [0, 1, 2, 3, 4], 							false, 14 ],
		["fall", "assets/images/damsel/princess_fallloop1_307x343_20fps_strip4.png", 		307, 343, [0, 1, 2, 3], 							true,  14 ],
		["jump", "assets/images/damsel/princess_jump1_307x343_12fps_strip3.png", 	 		307, 343, [0, 1, 2],								false, 24 ],
		["run", "assets/images/damsel/princess_run1_307x343_18fps_strip12.png", 	 		307, 343, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 	true,  18 ],
		["sword", "assets/images/damsel/princess_attack1_307x343_20fps_strip7.png",	 		307, 343, [0, 1, 2, 3, 4, 5, 6], 					false, 20 ],
		["land", "assets/images/damsel/princess_landrecoil_307x343_10fps_strip3.png",	 	307, 343, [0, 1, 2], 								false, 10 ],
		["awaken", "assets/images/damsel/princess_awaken_307x343_10fps_strip15.png",	 	307, 343, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],	false, 10 ],
		["hurt", "assets/images/damsel/princess_hurt1_307x343_14fps_strip4.png",	 		307, 343, [0, 1, 2, 3],								false,  14 ] ,
		["death", "assets/images/damsel/princess_deathSTART_307x343_14fps_strip5.png",	 	307, 343, [0, 1, 2, 3, 4],							false, 14 ],
		["deathloop", "assets/images/damsel/princess_deathLOOP_307x343_16fps_strip2.png",	307, 343, [0, 1],									true,  16 ],
		["intro", "assets/images/damsel/princess_INTRO_307x343_8fps_strip19.png",		 	307, 343, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], false, 8 ],
		["asleep", "", 307, 343, [], false, 0 ]
	
	];
	
    public static inline var RUN_SPEED:Int 		= 200;
	public static inline var JUMP_MIN:Int 		= 1500;
	public static inline var JUMP_MAX:Int 		= 5000;
	public static inline var JUMP_FRAMES:Int 	= 20;
	
	var jumpAmountMax:Int;
	var parentComponent:FlxPoint;
	
    var parent:PlayState;
    var state:Int;
	public var animctrl:AnimationController;
    
	var shooting:Float;
	var swinging:Float;
	var shootMax:Float;
	var swingMax:Float;
	
	var retainParent:Int = 0;
    var playerJumping:Bool = false;
	var playerJumpStart:Bool = false;
	var playerHurt:Bool = false;
	var playerDead:Bool = false;
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
	
	function checkIdle():Bool { return velocity.x == 0 && velocity.y == 0 && master != null; }
	function checkShoot():Bool { return shooting != -1; }
	function checkFall():Bool { return velocity.y > 0 && master == null; }
	function checkJump():Bool { return velocity.y < 0; }
	function checkRun():Bool { return velocity.y == 0 && velocity.x != 0 && ( ctrlLeft || ctrlRight ); }
	function checkSword():Bool { return swinging != -1; }
	function checkLand():Bool { return velocity.y <= 0; }
	function checkHurt():Bool { return playerHurt; }
	function checkDeath():Bool { return playerDead; }
	function checkDeathLoop():Bool { return playerDead; }
	
	function checkAsleep():Bool { return true; }
	function checkAwaken():Bool { return initSignal == SIG_PRINCESS_AWAKE; }
	function checkIntro():Bool { return initSignal == SIG_PRINCESS_ANGRY;  }
	
	function cancelShoot():Bool {
		var ret:Bool = !( animation.finished || shooting >= shootMax );
		if ( !ret )
			shooting = -1;
		return ret;
	}
	function cancelSword():Bool {
		var ret:Bool = !( animation.finished || swinging >= swingMax );
		if ( !ret )
			swinging = -1;
		return ret;
	}
	function cancelHurt():Bool {
		var ret:Bool = animation.finished;
		if ( ret )
			playerHurt = false;
		return !ret;
	}
	function cancelDead():Bool {
		return !animation.finished;
	}
	function cancelIntro():Bool {
		trace( "CANCEL " + initSignal + " " + SIG_PRINCESS_ANGRY );
		return (initSignal == SIG_PRINCESS_ANGRY);
	}
	
	public function buildAnimations():Void {
		var asleep 	= new AnimateThrower( ANIM_ASLEEP, checkAwaken, 6 );
		var awake 	= new AnimateThrower( ANIM_AWAKEN, checkAwaken, 7 );
		var intro 	= new AnimateThrower( ANIM_INTRO, checkIntro, 9 );
		var dead	= new AnimateThrower( ANIM_DEATH, checkDeath, 10 );
		var dedl	= new AnimateThrower( ANIM_DEATH_LOOP, checkDeathLoop, 11 );
		var hurt	= new AnimateThrower( ANIM_HURT, checkHurt, 12 );
		var shoot 	= new AnimateThrower( ANIM_SHOOT, checkShoot, 13 );
		var sword 	= new AnimateThrower( ANIM_SWORD, checkSword, 14 );
		var fall 	= new AnimateThrower( ANIM_FALL, checkFall, 15 );
		var jump 	= new AnimateThrower( ANIM_JUMP, checkJump, 16 );
		var run 	= new AnimateThrower( ANIM_RUN, checkRun, 17 );
		var idle 	= new AnimateThrower( ANIM_IDLE, checkIdle, 18 );
		var land	= new AnimateThrower( ANIM_LAND, checkLand, 19 );
		
		animctrl = new AnimationController( [
												new AnimateCatcher( ANIM_ASLEEP, [awake] ),
												new AnimateCatcher( ANIM_AWAKEN, [intro] ),
												new AnimateCatcher( ANIM_INTRO, [idle,fall,jump,run], cancelIntro ),
												new AnimateCatcher( ANIM_DEATH, [dedl], cancelDead ),
												new AnimateCatcher( ANIM_DEATH_LOOP, [] ),
												new AnimateCatcher( ANIM_IDLE, [dead, hurt, shoot, fall, jump, run, sword] ),
												new AnimateCatcher( ANIM_FALL, [dead, hurt, land] ), 
												new AnimateCatcher( ANIM_SHOOT, [dead, hurt, fall, jump, run, idle], cancelShoot ), 
												new AnimateCatcher( ANIM_JUMP, [dead, hurt, fall, idle, run, sword] ), 
												new AnimateCatcher( ANIM_RUN, [dead, hurt, fall, jump, idle, sword] ), 
												new AnimateCatcher( ANIM_SWORD, [dead, hurt, fall, jump, run, idle], cancelSword ), 
												new AnimateCatcher( ANIM_LAND, [dead, hurt, shoot, fall, jump, run, sword, idle] ), 
												new AnimateCatcher( ANIM_HURT, [fall, idle, run], cancelHurt ) 
											], 
											ANIM_ASLEEP );
	}
    
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
		state = -1;
		idtmr = 0;
		
		buildAnimations();
		setAnimation( ANIM_AWAKEN );
    }
    
    public override function update():Void {
		if ( !this.isActing ) {
			acceleration.x = 0;
			if ( !this.isDeadOrHurt() ) {
				handleInput();
				moveCharacter();
			}
		}
		setAnimation( animctrl.update() );
		resetShoot();
		
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
		
		if ( shooting != -1 )
			shooting += FlxG.elapsed;
		if ( swinging != -1 )
			swinging += FlxG.elapsed;
		
		if ( ctrlX )
			shootCrossbow();
		if ( ctrlZ )
			swingSword();
	}
	public function resetShoot() {
		if ( shooting >= shootMax )
			shooting = -1;
		if ( swinging >= swingMax )
			swinging = -1;
	}
	
	public function setHurt():Void {
		if ( playerHurt )
			return;
		playerHurt = true;
		
		var num = Math.random();
		if(num >=.6){
			FlxG.sound.play("assets/sounds/vrsfx/Licia/hurt1.wav", .3, false);
		} else if (num >= .3){
			FlxG.sound.play("assets/sounds/vrsfx/Licia/hurt2.wav", .3, false);
		} else {
			FlxG.sound.play("assets/sounds/vrsfx/Licia/hurt3.wav", .3, false);
		}
	}
	public function setDead():Void {
		FlxG.sound.play("assets/sounds/vrsfx/Licia/death.wav", .6, false);
		
		acceleration.y = 3200;
		drag.set( 0, 0 );
		FlxG.camera.follow( null );
		ignore = true;
		playerDead = true;
	}
	public function isHurt():Bool {
		return playerHurt;
	}
	public function isDead():Bool {
		return playerDead;
	}
	public function isDeadOrHurt():Bool {
		return playerDead || playerHurt;
	}
	public override function shouldCollide( other:PlatformCollision ):Bool {
		return super.shouldCollide( other );
	}
	public override function collision( other:PlatformCollision, xsep:Bool, ysep:Bool ):Void {
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
			
			
			var num = Math.random();
			if(num >=.6){
				FlxG.sound.play("assets/sounds/vrsfx/Licia/jump1.wav", .3, false);
			} else if (num >= .3){
				FlxG.sound.play("assets/sounds/vrsfx/Licia/jump2.wav", .3, false);
			} else {
				FlxG.sound.play("assets/sounds/vrsfx/Licia/jump3.wav", .3, false);
			}
			
		}
	}
	
	public function shootCrossbow():Void {
		if ( shooting == -1 && swinging == -1 && this.parent.bolts.length < 2) {
			shooting = 0;
			FlxG.sound.play("assets/sounds/bowshoot.wav", 1, false);
			if(facingLeft){
				var bolt:Bolt = new Bolt(this.x - width/4, this.y + height/2, -1, this.parent);
				this.parent.addBolt(bolt);
			} else {
				var bolt:Bolt = new Bolt(this.x + 3*width/4, this.y + height/2, 1, this.parent);
				this.parent.addBolt(bolt);
			}
		}
	}
	
	public function isSwinging():Bool {
		return swinging != -1;
	}
	public function swingSword():Void {
		if ( swinging != -1 || shooting != -1 )
			return;
		
		swinging = 0;
		
		var swingArea:FlxSprite = new FlxSprite(this.x, this.y);
		if (facingLeft) {
			swingArea.x = this.x - this.width * 1.5;
			swingArea.width = this.width * 2.5;
			swingArea.height = this.height;
		} else {
			swingArea.x = this.x;
			swingArea.width = this.width * 2.5;
			swingArea.height = this.height;
		}
		
		var d:Array<Bool> = [];
		var len:Int = this.parent.batShots.length;
		for(i in 0...len) {
			if (FlxG.overlap(this.parent.batShots[i], swingArea)) {
				trace( "overlap" );
				var num:Int= Std.random( 10 );
				if(num >= 6) {
					FlxG.sound.play("assets/sounds/vrsfx/Licia/sword1.wav", .3, false);
				} else if (num >= 3) {
					FlxG.sound.play("assets/sounds/vrsfx/Licia/sword2.wav", .3, false);
				} else {
					FlxG.sound.play("assets/sounds/vrsfx/Licia/sword3.wav", .3, false);
				}
				d.push( true );
			} else {
				d.push( false );
			}
		}
		for(i in 0...d.length){
			if(d[i]){
				this.parent.remove(this.parent.batShots[i]);
				this.parent.batShots.splice(i, 1);
			}
		}
		var len:Int = this.parent.walkers.length;
		for(i in 0...len) {
			if (FlxG.collide(this.parent.walkers[i], swingArea)) {
				var num = Math.random();
				if(num >=.6){
					FlxG.sound.play("assets/sounds/vrsfx/Licia/sword1.wav", .3, false);
				} else if (num >= .3){
					FlxG.sound.play("assets/sounds/vrsfx/Licia/sword2.wav", .3, false);
				} else {
					FlxG.sound.play("assets/sounds/vrsfx/Licia/sword3.wav", .3, false);
				}
				if(this.parent.walkers[i].x > this.x){
					this.parent.walkers[i].velocity.x = 1500;
				} else {
					this.parent.walkers[i].velocity.x = -1500;
				}
				this.parent.walkers[i].damage( 1 );
			}
		}
		for(i in 0...this.parent.batneyes.length){
				if(FlxG.collide(this.parent.batneyes[i], swingArea)){
					this.parent.batneyes[i].killByWeapon();
			}
		}
		for(i in 0...this.parent.shieldGuys.length){
			if(FlxG.collide(this.parent.shieldGuys[i], swingArea)){
					
					if ( this.parent.shieldGuys[i].shield.isDestroyed ) {
						this.parent.shieldGuys[i].damage( 1 );
					}
					this.parent.shieldGuys[i].destroyShield();
					
					if(this.parent.shieldGuys[i].x > this.x){
						this.parent.shieldGuys[i].velocity.x = 1500;
					} else {
						this.parent.shieldGuys[i].velocity.x = -1500;
					}
			}
		}
	}
	
	public function setAnimation( st:Int ) {
		if ( state != st ) {
			state = st;
			if ( state == ANIM_ASLEEP ) {
				loadGraphic( ANIMATIONS[ANIM_AWAKEN][ANIMI_FNAME],
							 true,
							 ANIMATIONS[ANIM_AWAKEN][ANIMI_W],
							 ANIMATIONS[ANIM_AWAKEN][ANIMI_H] );
			} else {
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
			}
			scale.set(.75, .75);
			setSize(width / 4, height / 1.75);
			offset.set(width * 1.5, height / 3);
		}
	}
	
	
	// ACTOR STUFF
	
	public var scr:Script;
	var isActing:Bool;
	var newAction:Bool = true;
	var initX:Float;
	var initY:Float;
	var initSignal:Int = -1;
	
	public function passToScript():Void {
		acceleration.y = 3200;
		isActing = true;
	}
	public function passToGame():Void {
		isActing = false;
	}
	
	public function move( direc:String, amount:Int, time:Float ):Void {
		trace( "MOVE" );
		if ( newAction ) {
			initX = x;
			initY = y;
			newAction = false;
		}
		switch ( direc ) {
			case "left":
				var check = ( initX - x >= amount );
				if ( !check )
					velocity.x = -cast(amount, Float) / time;
				else
					newAction = true;
			case "right":
				var check = ( x - initX >= amount );
				if ( !check )
					velocity.x = cast(amount, Float) / time;
				else
					newAction = true;
		}
	}
	public function moveTo( direc:String, amount:Int, time:Float ):Void {
		
	}
	public function impulse( direc:String, amount:Int ):Void {
		trace( "IMPULSE "+velocity.y );
		if ( newAction ) {
			velocity.y = -amount;
			newAction = false;
		}
		switch ( direc ) {
			case "up":
				if ( velocity.y == 0 )
					newAction = true;
			case "left":
				velocity.x = -amount;
				newAction = true;
			case "right":
				velocity.x = amount;
				newAction = true;
		}
	}
	public function signal( sig:Int ):Void { 
		trace( "SET SIGNAL " + sig );
		initSignal = sig;
	}
	public function ready():Bool {
		return newAction;
	}
}
