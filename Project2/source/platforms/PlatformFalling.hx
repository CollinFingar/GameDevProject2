package platforms;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;

class PlatformFalling extends FlxSprite implements PlatformCollision {

	public var overmind:platforms.PlatformGroup;
	public var slot:MoveBase;
	
	var hit:Bool = false;
	var changing:Bool = false;
	var done:Bool = false;
	
	public override function new( par:PlatformGroup, nx:Float, ny:Float ) {
		super( nx, ny );
		overmind = par;
		overmind.add( this );
		slot = null;
		
		loadGraphic( "assets/images/misc/platform_tofall_361x192_20fps_strip5.png", true, 361, 192 );
		animation.add( "break", [0, 1, 2, 3, 4], 20, false );
		
		offset.set(width / 4, height / 3);
		setSize(width / 2, height / 3);
		immovable = true;
	}
	public function setSlot( obj:MoveBase ):Void {
		slot = obj;
	}
	public function collisionCheck( obj:MoveBase ):Void {
		if ( !obj.ignore && FlxG.overlap( this, obj ) ) {
			var xs = false;
			var ys = false;
			if ( obj.shouldCollide( this ) ) {
				xs = FlxObject.separateX( obj, this );
				ys = FlxObject.separateY( obj, this );
			}
			if ( xs || ys )
				obj.collision( this, xs, ys );
			if ( ys && ( touching & FlxObject.UP != 0 ) ) {
				hit = true;
			}
		}
	}
	
	public override function update():Void {
		acceleration.y = 0;
		if ( done ) {
			acceleration.y = 3300;
			alpha -= 0.05;
			if ( alpha == 0 ) {
				visible = false;
			}
		} else if ( changing && animation.finished ) {
			done = true;
			changing = false;
		} else if ( hit ) {
			animation.play( "break", false );
			changing = true;
			hit = false;
		}
		trace( done, changing, hit );
		super.update();
	}
	
}