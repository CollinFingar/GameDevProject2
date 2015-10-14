package;

import flixel.FlxSprite;
import flixel.FlxObject;
import AnimationController;

class Prince extends MoveBase implements Actor {
	
	static public inline var ANIM_IDLE = 0;
	static public inline var ANIM_JUMP = 1;
	static public inline var ANIM_LAND = 2;
	static public inline var ANIM_WALK = 3;
	static public inline var ANIM_DEAD = 4;
	
	var parent:PlayState;
	var isDead:Bool;
	var anim:AnimationController;
	var state:Int;
	
	function checkJump():Bool { return velocity.y != 0; }
	function checkLand():Bool { return ( touching & FlxObject.DOWN ) != 0; }
	function checkDead():Bool { return isDead; }
	function checkWalk():Bool { return velocity.x != 0 && velocity.y == 0; }
	function checkIdle():Bool { return velocity.x == 0 && velocity.y == 0; }
	
	function cancelLand():Bool {
		return !animation.finished;
	}
	
	function build_animations() {
		var dead = new AnimateThrower( ANIM_DEAD, checkDead, 0 );
		var land = new AnimateThrower( ANIM_LAND, checkLand, 1 );
		var jump = new AnimateThrower( ANIM_JUMP, checkJump, 2 );
		var walk = new AnimateThrower( ANIM_WALK, checkWalk, 3 );
		var idle = new AnimateThrower( ANIM_IDLE, checkIdle, 4 );
		
		anim = new AnimationController( [ 	new AnimateCatcher( ANIM_DEAD, [] ),
											new AnimateCatcher( ANIM_JUMP, [dead, land] ),
											new AnimateCatcher( ANIM_LAND, [dead, walk, jump, idle], cancelLand ),
											new AnimateCatcher( ANIM_WALK, [dead, idle, jump] ),
											new AnimateCatcher( ANIM_IDLE, [dead, walk, jump] ) ], ANIM_IDLE );
	}
	
	public override function new(X:Float = 0, Y:Float = 0, Parent:PlayState) {
		super(X, Y);
		parent = Parent;
		drag.set(150, 0);
		acceleration.y  = 3200;
		build_animations();
	}
	
	public override function update():Void {
		setAnimations( anim.update() );
		super.update();
	}
	
	function h1():Void {
		scale.set(.75, .75);
		setSize(width / 3, height / 1.75);
		offset.set(width , height / 3);
	}
	function h2():Void {
		scale.set(.75, .75);
		setSize(width / 3, height / 1.86 );
		offset.set(width, height / 3);
	}
	public function setAnimations( st:Int ) {
		if ( state != st ) {
			state = st;
			switch( state ) {
				case ANIM_IDLE:
					loadGraphic( "assets/images/misc/prince_idle.png", false );
					h1();
				case ANIM_JUMP:
					loadGraphic( "assets/images/misc/prince_jump_351x369_10fps_strip3.png", true, 351, 369 );
					animation.add( "jump", [0, 1, 2], 10, false );
					animation.play( "jump", false );
					h1();
				case ANIM_LAND:
					loadGraphic( "assets/images/misc/Prince_land_351x369_10fps_strip3.png", true, 351, 369 );
					animation.add( "land", [0, 1, 2], 10, false );
					animation.play( "land", false );
					h1();
				case ANIM_WALK:
					loadGraphic( "assets/images/misc/prince_walk_351x369_10fps_strip6.png", true, 351, 369 );
					animation.add( "walk", [0, 1, 2, 3, 4, 5], 10, true );
					animation.play( "walk", false );
					h1();
				case ANIM_DEAD:
					loadGraphic( "assets/images/misc/prince_unconcsifdisfi_351x369_16fps_strip4.png", true, 351, 369 );
					animation.add( "dead", [0, 1, 2, 3], 16, true );
					animation.play( "dead", false );
					h2();
			}
		}
	}
	
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
				flipX = true;
				var check = ( initX - x >= amount );
				if ( !check )
					velocity.x = -cast(amount, Float) / time;
				else
					newAction = true;
			case "right":
				flipX = false;
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
		switch ( direc ) {
			case "up":
				if ( newAction ) {
					velocity.y = -amount;
					newAction = false;
				}
				if ( velocity.y == 0 ) {
					velocity.x = 0;
					newAction = true;
				}
			case "left":
				flipX = true;
				velocity.x = -amount;
				newAction = true;
			case "right":
				flipX = false;
				velocity.x = amount;
				newAction = true;
		}
	}
	public function signal( sig:Int ):Void { 
		if ( sig == 0 ) {
			isDead = true;
		} else if ( sig == 1 ) {
			active = true;
			visible = true;
		}
	}
	public function ready():Bool {
		return newAction;
	}
}

