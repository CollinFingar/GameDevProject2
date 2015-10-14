package;

import AnimationController;
import flixel.FlxSprite;

class DustCloud extends FlxSprite implements Actor {
	public var scr:Script;
	var state:Int = 1;
	
	public override function new( X:Float, Y:Float, par:PlayState ) {
		super(X, Y);
		par.add( this );
		visible = false;
		
		loadGraphic( "assets/images/misc/dustcloud_appear_351x369_16fps_strip3.png", true, 351, 369 );
		animation.add( "start", [0, 1, 2], 16, false );
	}
	
	public override function update() {
		super.update();
		if ( visible && animation.finished )
			updateAnim();
	}
	public function updateAnim() {
		trace ("UPDATE ANIM");
		switch ( state ) {
			case 1: // going
				loadGraphic( "assets/images/misc/dustcloud_loop_351x369_12fps_strip12.png", true, 351, 369 );
				animation.add( "going", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 12, false );
				animation.play( "going" );
				state = 2;
			case 2: // finish
				loadGraphic( "assets/images/misc/dustcloud_disperse_351x369_16fps_strip4.png", true, 351, 369 );
				animation.add( "finish", [0, 1, 2, 3], 16, false );
				animation.play( "finish" );
				state = 3;
			case 3:
				visible = false;
		}
	}
	
	public function passToScript():Void { }
	public function passToGame():Void { }
	public function move( direc:String, amount:Int, time:Float ):Void { }
	public function moveTo( direc:String, amount:Int, time:Float ):Void { }
	public function impulse( direc:String, amount:Int ):Void { }
	
	
	public function signal( sig:Int ):Void {
		visible = true;
		animation.play( "start" );
	}
	public function ready():Bool {
		return true;
	}
}