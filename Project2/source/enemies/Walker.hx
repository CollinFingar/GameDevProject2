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
class Walker extends FlxSprite
{
    public static inline var RUN_SPEED:Int =  200;
    var parent:PlayState;
	var facingLeft:Bool = true;
	var anim:AnimationController;
	var walkerHurt:Bool = false;
	var state:Int = -1;
	var index:Int = -1;
	
	public var healthRemaining:Int = 3;
	
	static public inline var ANIM_WALK:Int = 0;
	static public inline var ANIM_HURT:Int = 1;
	static public inline var ANIM_DEATH:Int = 2;
	
	function checkWalk():Bool { return true; }
	function checkHurt():Bool { return walkerHurt; }
	function checkDeath():Bool { return ( healthRemaining <= 0 ); }
	
	function cancelHurt():Bool {
		var ret:Bool = animation.finished;
		if ( ret ) walkerHurt = false;
		return !ret;
	}
	function cancelDeath():Bool {
		var ret:Bool = animation.finished;
		if ( ret ) {
			removeFromParent();
			kill();
		}
		return !ret;
	}
	
	function build_animation():Void {
		var walk = new AnimateThrower( ANIM_WALK, checkWalk, 2 );
		var hurt = new AnimateThrower( ANIM_HURT, checkHurt, 1 );
		var death = new AnimateThrower( ANIM_DEATH, checkDeath, 0 );
		
		anim = new AnimationController( [ 
											new AnimateCatcher( ANIM_WALK, [death, hurt] ),
											new AnimateCatcher( ANIM_HURT, [walk, death], cancelHurt ),
											new AnimateCatcher( ANIM_DEATH, [walk, hurt], cancelDeath )
										], ANIM_WALK );
	}
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X, Y);
        makeGraphic(80, 120, FlxColor.CRIMSON);
		
		
        drag.set(RUN_SPEED * 3, RUN_SPEED * 3);
        maxVelocity.set(RUN_SPEED * 1, RUN_SPEED * 3);
        acceleration.y = 3000;
        parent = Parent;
		
		build_animation();
    }
	
	public function isDead():Bool {
		return ( healthRemaining <= 0 );
	}
	public function damage( val:Int ) {
		if ( val > 0 )
			walkerHurt = true;
		healthRemaining -= val;
		trace( "WALKER HURT" );
		
		
		if(healthRemaining > 0){
			var num = Math.random();
			if(num >=.6){
				FlxG.sound.play("assets/sounds/vrsfx/guard/guardhit1.wav", .3, false);
			} else if (num >= .3){
				FlxG.sound.play("assets/sounds/vrsfx/guard/guardhit2.wav", .3, false);
			} else {
				FlxG.sound.play("assets/sounds/vrsfx/guard/guardhit3.wav", .3, false);
			}
		} else {
			var num = Math.random();
			if(num >=.5){
				FlxG.sound.play("assets/sounds/vrsfx/guard/guarddie1.wav", .3, false);
			} else {
				FlxG.sound.play("assets/sounds/vrsfx/guard/guarddie2.wav", .3, false);
			}
		}
		
	}
	public function removeFromParent():Void {
		this.parent.remove( this );
		this.parent.walkers.remove( this );
	}
    
    public override function update():Void {
        acceleration.x = 0;
		if ( !walkerHurt ) {
			if(facingLeft && velocity.x == 0){
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
		}
		
		setAnimation( anim.update() );
		
        super.update();
    }
	public function setAnimation( st:Int ) {
		if ( state != st ) {
			state = st;
			trace( "NEW STATE = ",state );
			switch( state ) {
				case ANIM_WALK:
					loadGraphic("assets/images/enemies/walker_walk_307x343_10fps_strip6.png", true, 307, 343);
					animation.add("walk", [0, 1, 2, 3, 4, 5], 10, true);
					animation.play("walk", false);
				case ANIM_HURT:
					loadGraphic("assets/images/enemies/walker_hurt_307x343_12fps_strip3.png", true, 307, 343);
					animation.add("hurt", [0, 1, 2], 12, false);
					animation.play("hurt", false);
				case ANIM_DEATH:
					loadGraphic("assets/images/enemies/walker_death_307x343_14fps_strip10.png", true, 307, 343);
					animation.add("death", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, false);
					animation.play("death", false);
				default:
					return;
			}
			scale.set(.75, .75);
			setSize(width / 2, height / 1.75);
			offset.set(width / 2.75, height / 3);
			
		}
	}
    
    
}
