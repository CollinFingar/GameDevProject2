package platforms;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import openfl.Assets;

class PlatformTiles extends FlxTilemap implements PlatformCollision {
	public var name:String;
	
	public var overmind:platforms.PlatformGroup;
	public var slot:MoveBase;
	
	var parent:PlatformTiles;
	
	var control:Bool;
	var twidth:Int;
	var theight:Int;
	
	public var relX:Float;
	public var relY:Float;
	
	public var orig_pos:FlxPoint;
	
	public override function new( par:platforms.PlatformGroup, n:String, csv:String, col:Array<Int>, ncol:Bool = true, nx:Int=0, ny:Int=0 ) {
		super();
		
		loadMap( Assets.getText( csv ), par.tilepng, 64, 64 );
		for ( x in col ) {
			setTileProperties(x, (ncol)?FlxObject.ANY:FlxObject.NONE);
		}
		twidth = cast( width / widthInTiles, Int );
		theight = cast( height / heightInTiles, Int );
		x = nx * twidth;
		y = ny * theight;
		orig_pos = new FlxPoint( x, y );
		relX = 0;
		relY = 0;
		
		name = n;
		overmind = par;
		parent = null;
		
		overmind.add( this );
	}
	
	public function setParent( par:PlatformTiles ) {
		parent = par;
	}
	public function setSlot( obj:MoveBase ) {
		slot = obj;
	}
	
	public function hspeed():Float {
		var ret:Float;
		if ( parent != null )
			ret = speedX() + parent.hspeed();
		else
			ret = speedX();
		return ret;
	}
	public function vspeed():Float {
		var ret:Float;
		if ( parent != null )
			ret = speedY() + parent.vspeed();
		else
			ret = speedY();
		return ret;
	}
	
	function adjustSlot( nx:Float, ny:Float ) {
		if ( slot != null ) {
			slot.x += nx;
			slot.y += ny;
		}
	}
	public function moveX( val:Float ):Void {
		adjustSlot( val, 0 );
		relX += val;
		x += val;
	}
	public function moveY( val:Float ):Void {
		adjustSlot( 0, val );
		relY+= val;
		y += val;
	}
	public function moveXTo( val:Float ):Void {
		adjustSlot( val - x, 0 );
		relX += val - x;
		x = val;
	}
	public function moveYTo( val:Float ):Void {
		adjustSlot( 0, val - y );
		relY += val - y;
		y = val;
	}
	public function moveRelXTo( val:Float ):Void {
		adjustSlot( relX - val, 0 );
		x += relX - val;
		relX = val;
	}
	public function moveRelYTo( val:Float ):Void {
		adjustSlot( 0, relY - val );
		y += relY - val;
		relY = val;
	}
	
	public function collisionCheck( obj:MoveBase ):Void {
		var xs = false;
		var ys = false;
		obj.velocity.x -= x - orig_pos.x;
		obj.velocity.y -= y - orig_pos.y;
		if ( !obj.ignore && FlxG.overlap( this, obj ) ) {
			if ( obj.shouldCollide( this ) ) {
				xs = FlxObject.separateX( obj, this );
				ys = FlxObject.separateY( obj, this );
			}
			if ( xs || ys )
				obj.collision( this, xs, ys );
		}
		if ( !xs ) obj.velocity.x += x - orig_pos.x;
		if ( !ys ) obj.velocity.y += y - orig_pos.y;
	}
	public override function update():Void {
		orig_pos.set( x, y );
		moveX( hspeed() );
		moveY( vspeed() );
		super.update();
	}
	
	// OVERRIDE THESE FOR MOVEMENT
	public function speedX():Float {
		return 0;
	}
	public function speedY():Float {
		return 0;
	}
}