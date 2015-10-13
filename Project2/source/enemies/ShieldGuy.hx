package enemies;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import AnimationController;

/**
 * ...
 * @author ...
 */
class ShieldGuy extends FlxSprite
{
    public static inline var RUN_SPEED:Int =  200;
	
    var parent:PlayState;
	var facingLeft:Bool = true;
	
	public var hangingOut:Bool = true; // he's just hanging out, why you gotta attack him?
	public var isAttacking:Bool = false; // this is what you get
	public var isHurt:Bool = false;
	
	public var shield:Shield;
	public var anim:AnimationController;
	public var state:Int = -1;
	
	public var healthRemaining:Int = 5;
	
	static public inline var ANIM_ATTACK = 0;
	static public inline var ANIM_DEATH = 1;
	static public inline var ANIM_HURT = 2;
	static public inline var ANIM_IDLE = 3;
	static public inline var ANIM_WALK = 4;
	
	function checkAttack() { return isAttacking; }
	function checkDeath() { return (healthRemaining <= 0); }
	function checkHurt() { return isHurt; }
	function checkWalk() { return !hangingOut && velocity.x != 0 && velocity.y == 0; }
	function checkIdle() { return hangingOut || velocity.y != 0; }
	
	function cancelAttack() {
		var ret = animation.finished;
		if ( ret ) {
			isAttacking = false;
		}
		return !ret;
	}
	function cancelHurt() {
		var ret = animation.finished;
		if ( ret ) {
			isHurt = false;
		}
		return !ret;
	}
	function cancelDeath() {
		var ret = animation.finished;
		if ( ret ) {
			removeFromParent();
			kill();
		}
		return !ret;
	}
	
	function build_animation():Void {
		var death = new AnimateThrower( ANIM_DEATH, checkDeath, 0 );
		var attack = new AnimateThrower( ANIM_ATTACK, checkAttack, 1 );
		var hurt = new AnimateThrower( ANIM_HURT, checkHurt, 2 );
		var walk = new AnimateThrower( ANIM_WALK, checkWalk, 3 );
		var idle = new AnimateThrower( ANIM_IDLE, checkIdle, 4 );
		
		anim = new AnimationController( [
											new AnimateCatcher( ANIM_DEATH, [], cancelDeath ),
											new AnimateCatcher( ANIM_HURT, [walk,idle,death,attack], cancelHurt ),
											new AnimateCatcher( ANIM_ATTACK, [walk,idle,death,hurt], cancelAttack ),
											new AnimateCatcher( ANIM_WALK, [idle,death,hurt,attack] ),
											new AnimateCatcher( ANIM_IDLE, [walk,death,hurt,attack] )
										], ANIM_IDLE );
	}
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState)
    {
        super(X, Y);
        makeGraphic(80, 120, FlxColor.INDIGO);
		
        drag.set(RUN_SPEED * 3, RUN_SPEED * 3);
        maxVelocity.set(RUN_SPEED * 1, RUN_SPEED * 3);
        acceleration.y = 3200;
        parent = Parent;
		parent.add( this );
		
		shield= new Shield(this);
		parent.add( shield );
		
		build_animation();
    }
	
	public function isDead():Bool {
		return ( healthRemaining <= 0 );
	}
	public function destroyShield():Void {
		shield.isDestroyed = true;
	}
	public function damage( val:Int ):Void {
		hangingOut = false;
		if ( val > 0 )
			isHurt = true;
		healthRemaining -= val;
		if ( healthRemaining <= 0 ) {
			acceleration.x = 0;
		}
		trace( "SHIELD GUY HURT" );
	}
	public function removeFromParent():Void {
		this.parent.remove( this );
		this.parent.shieldGuys.remove( this );
	}
    
    public override function update():Void {
		if ( !parent.player.isDead() ) {
			if ( parent.player.x < x ) {
				flipX = true;
			} else {
				flipX = false;
			}
		}

		if ( !isAttacking ) {
			if ( Std.random(100) == 0 ) {
				isAttacking = true;
			}
		}
		
		acceleration.x = 0;
		if ( !isAttacking && !isHurt && !hangingOut ) {
			if ( parent.player.x < x ) {
				acceleration.x = -drag.x;
			} else {
				acceleration.x = drag.x;
			}
		}
		
		
		setAnimation( anim.update() );
        super.update();
		
		shield.setAnimation( shield.anim.update() );
		shield.x = x;
		shield.y = y;
		shield.flipX = flipX;
    }
	
	public function setAnimation( st:Int ):Void {
		if ( state != st ) {
			trace( "SHIELD GUY NEW ANIM " + st );
			state = st;
			switch( state ) {
				case ANIM_ATTACK:
					loadGraphic("assets/images/enemies/skelly_attack1_450x343_16fps_strip6.png", true, 450, 343);
					animation.add("attack", [0, 1, 2, 3, 4, 5], 16, false);
					animation.play("attack", false);
				case ANIM_DEATH:
					loadGraphic("assets/images/enemies/skelly_death_340x343_14fps_strip17.png", true, 340, 343);
					animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16], 14, false );
					animation.play("death", false);
				case ANIM_HURT:
					loadGraphic("assets/images/enemies/skelly_hurt_340x343_16fps_strip9.png", true, 340, 343);
					animation.add("hurt", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 16, false);
					animation.play("hurt", false);
				case ANIM_IDLE:
					loadGraphic("assets/images/enemies/skelly_idle1_340x343_8fps_strip3.png", true, 340, 343);
					animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8, true);
					animation.play("idle", false);
				case ANIM_WALK:
					loadGraphic("assets/images/enemies/skelly_walk1_340x343_12fps_strip7.png", true, 340, 343);
					animation.add("walk", [0, 1, 2, 3, 4, 5, 6], 12, true);
					animation.play("walk", false);
				default:
					return;
			}
			scale.set(.75, .75);
			setSize(width / 2, height / 1.75);
			offset.set(width/1.9, height/3);
		}
	}
    
}
