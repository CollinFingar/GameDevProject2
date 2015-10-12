package platforms;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import openfl.Assets;

class PlatformCircle extends PlatformController {
	var orig:FlxPoint;
	var r:Float;
	var s:Float;
	var current:Float;
	
	public override function new( nx:Float, ny:Float, radius:Float, speed:Float, start:Float = 0 ) { /*___IN_RADIANS___*/
		super();
		orig = new FlxPoint( nx, ny );
		r = radius;
		s = speed;
		current = start;
	}
	function adjustPos():Void {
		if ( slave != null ) {
			var nx = orig.x + r * Math.cos( current );
			var ny = orig.y + r * Math.sin( current );
			
			slave.moveXTo( nx );
			slave.setSpeedX( nx - slave.x );
			
			slave.moveYTo( ny );
			slave.setSpeedX( ny - slave.y );
		}
	}
	public override function setObject():Void {
		adjustPos();
	}
	public override function control():Void {
		super.control();
		current += s;
		while ( current > Math.PI * 2 )
			current -= Math.PI * 2;
		adjustPos();
	}
}