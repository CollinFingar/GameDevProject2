package platforms;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformMoveBasic extends PlatformTiles {
	
	var controller:PlatformController;
	var hspd:Float;
	var vspd:Float;
	
	public override function new( par:platforms.PlatformGroup, n:String, csv:String, col:Array<Int>, ncol:Bool = true, nx:Int = 0, ny:Int = 0 ) {
		super( par, n, csv, col, ncol, nx, ny );
		hspd = 0;
		vspd = 0;
		controller = null;
	}
	public function setControl( ctrl:PlatformController = null ) {
		if ( controller != null )
			controller.slave = null;
		controller = ctrl;
		if ( controller != null ) {
			controller.slave = this;
			controller.setObject();
		}
	}
	
	public override function update():Void {
		super.update();
		if ( controller != null )
			controller.control();
	}
	public function setSpeedX( xval:Float ):Void {
		hspd = xval;
	}
	public function setSpeedY( yval:Float ):Void {
		vspd = yval;
	}
	public override function speedX():Float {
		return hspd;
	}
	public override function speedY():Float {
		return vspd;
	}
	
	static public function makeController( platMove:PlatformMoveBasic, spd:Int = 3 ) {
		var starts:Array<FlxPoint> = platMove.getTileCoords(64, true);
		var ends:Array<FlxPoint> = platMove.getTileCoords(63, true);
		
		var endpt:FlxPoint = ends[0];
		
		var lowest:FlxPoint = new FlxPoint( 30000, 30000 );
		var highest:FlxPoint = new FlxPoint( 0, 0 );
		
		for ( i in starts ) {
			if ( i.x < lowest.x ) lowest.x = i.x;
			if ( i.x > highest.x ) highest.x = i.x;
			if ( i.y < lowest.y ) lowest.y = i.y;
			if ( i.y > highest.y ) highest.y = i.y;
		}
		for ( i in starts ) {
			var tx:Int = Std.int(i.x / 64.0);
			var ty:Int = Std.int(i.y / 64.0);
			var val:Int = 18;
			if ( i.x == lowest.x ) {
				if ( i.y == highest.y ) {
					val = 2;
				} else {
					val = 17;
				}
			} else if ( i.x == highest.x ) {
				if ( i.y == highest.y ) {
					val = 4;
				} else {
					val = 19;
				}
			} else if ( i.y == highest.y ) {
				val = 3;
			}
			platMove.setTile( tx, ty, val );
		}
		var ex:Int = Std.int(endpt.x / 64.0);
		var ey:Int = Std.int(endpt.y / 64.0);
		platMove.setTile( ex, ey, -1 );
		trace( lowest, highest );
		trace( endpt );
		
		var btwX = lowest.x <= endpt.x && endpt.x <= highest.x;
		var btwY = lowest.y <= endpt.y && endpt.y <= highest.y;
		if ( btwX && !btwY ) {
			trace( endpt.y - highest.y );
			platMove.setControl( new PlatformUpDown( 0, cast(endpt.y - highest.y,Int), spd ) );
		} else if ( !btwX && btwY ) {
			platMove.setControl( new PlatformUpDown( 0, cast(endpt.y - highest.y,Int), spd ) );
		}
	}
}