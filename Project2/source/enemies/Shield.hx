package enemies;


import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import haxe.Constraints.FlatEnum;
import AnimationController;
/**
 * ...
 * @author Team 8
 */
class Shield extends FlxSprite
{
	static public inline var ANIM_WALK = 0;
	static public inline var ANIM_IDLE = 1;
	static public inline var ANIM_ATTACK = 2;
	static public inline var ANIM_DESTROYED = 3;

    var parent:ShieldGuy;
	var state:Int = -1;
	
	public var anim:AnimationController;
	public var isDestroyed:Bool = false;
	
	function checkWalk():Bool { return parent.state == ShieldGuy.ANIM_WALK; }
	function checkIdle():Bool { return parent.state == ShieldGuy.ANIM_IDLE; }
	function checkAttack():Bool { return parent.state == ShieldGuy.ANIM_ATTACK; }
	function checkDestroyed():Bool { return isDestroyed; }
	
	function cancelDestroyed():Bool {
		var ret = animation.finished;
		if ( ret ) {
			visible = false;
		}
		return !ret;
	}
	
	function build_animation():Void {
		var destroy = new AnimateThrower( ANIM_DESTROYED, checkDestroyed, 0 );
		var walk = new AnimateThrower( ANIM_WALK, checkWalk, 1 );
		var idle = new AnimateThrower( ANIM_IDLE, checkIdle, 2 );
		var attack = new AnimateThrower( ANIM_ATTACK, checkAttack, 3 );
		
		anim = new AnimationController( [ new AnimateCatcher( ANIM_DESTROYED, [], cancelDestroyed ),
										  new AnimateCatcher( ANIM_WALK, [destroy,idle,attack], cancelDestroyed ),
										  new AnimateCatcher( ANIM_ATTACK, [destroy,idle,walk] ),
										  new AnimateCatcher( ANIM_IDLE, [destroy,walk,attack] ) ], ANIM_IDLE );
	}
	
    public function new( par:ShieldGuy )
    {
		super(par.x, par.y);
		parent = par;
		build_animation();
    }
	
	public function setAnimation( st:Int ):Void {
		if ( st != state ) {
			trace( "SHIELD NEW ANIM " + st );
			state = st;
			switch ( state ) {
				case ANIM_WALK:
					loadGraphic( "assets/images/enemies/skellyshield_WALK_378x343_12fps_strip7.png", true, 378, 343 );
					animation.add("walk", [0, 1, 2, 3, 4, 5, 6], 12, true);
					animation.play( "walk", false );
				case ANIM_IDLE:
					loadGraphic( "assets/images/enemies/skellyshield_idle1_340x343_8fps_strip3.png", true, 340, 343 );
					animation.add("idle", [0, 1, 2], 8, true);
					animation.play( "idle", false );
				case ANIM_ATTACK:
					loadGraphic( "assets/images/enemies/skellyshield_attack1_450x343_16fps_strip6.png", true, 450, 343 );
					animation.add("attack", [0, 1, 2, 3, 4, 5], 16, false);
					animation.play( "attack", false );
				case ANIM_DESTROYED:
					loadGraphic( "assets/images/enemies/skellyshield_Destroyed_340x343_16fps_strip5.png", true, 340, 343 );
					animation.add( "DED", [0, 1, 2, 3, 4], 16, false);
					animation.play( "DED", false );
				default:
					return;
			}
			scale.set(.75, .75);
			setSize(width / 2.5, height / 1.75);
			offset.set(width/1.9, height/3);
		}
	}
	
}