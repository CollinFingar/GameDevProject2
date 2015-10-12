package platforms;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformUpDown extends PlatformController {
	var minHeight:Int;
	var maxHeight:Int;
	var mspd:Int;
	
	public override function new( mn:Int, mx:Int, spd:Int = 3 ) {
		super();
		minHeight = cast(Math.max( cast(mn,Float), cast(mx,Float) ),Int);
		maxHeight = cast(Math.min( cast(mn,Float), cast(mx,Float) ),Int);
		mspd = spd;
	}
	public override function setObject():Void {
		slave.setSpeedY( (maxHeight > minHeight)? -mspd:mspd );
	}
	public override function control():Void {
		super.control();
		if ( slave.relY < maxHeight ) {
			
			slave.moveRelYTo( maxHeight );
			slave.setSpeedY( -slave.speedY() );
			
		} else if ( slave.relY > minHeight ) {
			
			slave.moveRelYTo( minHeight );
			slave.setSpeedY( -slave.speedY() );
			
		}
	}
}