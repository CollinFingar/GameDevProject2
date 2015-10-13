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
class Batneye extends FlxSprite
{
    public static inline var MOVE_SPEED:Int =  70;
    var parent:PlayState;
	var facingLeft:Bool = true;
	public var goingUp:Bool = true;
	
	var maxHeight:Float;
	var minHeight:Float;
	var shootRate:Int;
	var shootIndex:Int;
	var shootyBit:FlxSprite; // sprite for shooting particle effect
	
	var deadBySlash:Bool = false;
	var deadByStomp:Bool = false;
	var changed:Bool = false;
	
	var anim:AnimationController;
	var state:Int = -1;
	
	static public inline var ANIM_IDLE:Int = 0;
	static public inline var ANIM_DEATH_SLASH:Int = 1;
	static public inline var ANIM_DEATH_STOMP:Int = 2;
	
	function checkIdle():Bool { return true; }
	function checkStomped():Bool { return deadByStomp; }
	function checkSlashed():Bool { return deadBySlash; }
	
	function cancelDead():Bool {
		var ret = animation.finished;
		if ( ret ) {
			removeFromParent();
			kill();
		}
		return !ret;
	}
	
	function build_animation():Void {
		var idle = new AnimateThrower( ANIM_IDLE, checkIdle, 2 );
		var stomp = new AnimateThrower( ANIM_DEATH_STOMP, checkStomped, 1 );
		var slash = new AnimateThrower( ANIM_DEATH_SLASH, checkSlashed, 0 );
		
		anim = new AnimationController( [
											new AnimateCatcher( ANIM_IDLE, [stomp, slash] ),
											new AnimateCatcher( ANIM_DEATH_STOMP, [], cancelDead ),
											new AnimateCatcher( ANIM_DEATH_SLASH, [], cancelDead )
										], ANIM_IDLE );
	}
    
    public function new(X:Float=0, Y:Float=0, SR:Int = 70, Parent:PlayState) 
    {
        super(X, Y);
		
        drag.set(MOVE_SPEED * 3, MOVE_SPEED * 3);
        maxVelocity.set(MOVE_SPEED * 1, MOVE_SPEED * 3);
		
        parent = Parent;
		maxHeight = Y +300;
		minHeight = Y;
		shootRate = SR;
		shootIndex = 0;
		
		shootyBit = new FlxSprite(x, y);
		shootyBit.loadGraphic( "assets/images/enemies/batshotSTART_307x266_20fps_strip5.png", true );
		shootyBit.visible = false;
		shootyBit.animation.add("shoot", [0, 1, 2, 3, 4], 20, false);
		parent.add( shootyBit );
		
		build_animation();
    }
	
	public function isDead() {
		return ( deadBySlash || deadByStomp );
	}
	public function removeFromParent():Void {
		this.parent.remove( this );
		this.parent.batneyes.remove( this );
	}
	public function killByStomp():Void {
		velocity.set();
		deadByStomp = true;
	}
	public function killByWeapon():Void {
		velocity.set();
		deadBySlash = true;
	}
    
    public override function update():Void {
        velocity.y = 0;
		
		if ( !isDead() ) {
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
			
			if ( shootyBit.visible == false ) {
				shootIndex += 1;
				if(shootIndex % shootRate == 0){
					shoot();
				}
			} else {
				if ( animation.finished ) {
					shootyBit.visible = false;
					shoot();
				}
			}
		}
		
		setAnimation( anim.update() );
        super.update();
    }
	
	public function prepareShot():Void {
		if ( facingLeft ) {
			shootyBit.flipX = false;
			shootyBit.x = x;
		} else {
			shootyBit.flipX = true;
			shootyBit.x = x;
		}
		shootyBit.y = y;
		shootyBit.visible = true;
		shootyBit.animation.play( "shoot", false );
	}
	public function shoot():Void {
		if(facingLeft){
			var shot:Batshot = new Batshot(this.x + width / 4, this.y  + height / 2, -1, this.parent);
			this.parent.batShots.push(shot);
			this.parent.add(shot);
		} else {
			var shot:Batshot = new Batshot(this.x + 3*width / 4, this.y  + height / 2, 1, this.parent);
			this.parent.batShots.push(shot);
			this.parent.add(shot);

		}
	}
	public function setAnimation( st:Int ) {
		if ( state != st ) {
			state = st;
			switch( state ) {
				case ANIM_IDLE:
					loadGraphic("assets/images/enemies/bat_idle1_307x266_14fps_strip5.png", true, 307, 266);
					animation.add("idle", [0, 1, 2, 3, 4], 14, true);
					animation.play("idle", false);
				case ANIM_DEATH_SLASH:
					loadGraphic("assets/images/enemies/bat_cutdeath1_307x266_14fps_strip10.png", true, 307, 266);
					animation.add("slash", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, false);
					animation.play("slash", false);
				case ANIM_DEATH_STOMP:
					loadGraphic("assets/images/enemies/bat_stompdeath1_307x266_14fps_strip12.png", true, 307, 266);
					animation.add("stomp", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 14, false);
					animation.play("stomp", false);
			}
			scale.set(.75, .75);
			setSize(width / 2, height / 1.75);
			offset.set(width/2.75, height/3);
		}
	}
    
    
}
