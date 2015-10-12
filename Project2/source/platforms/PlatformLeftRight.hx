package platforms;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformLeftRight extends PlatformController {
	var minWidth:Int;
	var maxWidth:Int;
	var mspd:Int;
	
	public override function new( mn:Int, mx:Int, spd:Int = 3 ) {
		super();
		minWidth = cast(Math.min( cast(mn,Float), cast(mx,Float) ),Int);
		maxWidth = cast(Math.max( cast(mn,Float), cast(mx,Float) ),Int);
		mspd = spd;
	}
	public override function setObject():Void {
		slave.setSpeedX( (maxWidth > minWidth)? -mspd:mspd );
	}
	public override function control():Void {
		super.control();
		if ( slave.relX < maxWidth ) {
			
			slave.moveRelXTo( maxWidth );
			slave.setSpeedX( -slave.speedX() );
			
		} else if ( slave.relX > minWidth ) {
			
			slave.moveRelXTo( minWidth );
			slave.setSpeedX( -slave.speedX() );
			
		}
	}
}