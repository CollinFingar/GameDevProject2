package platforms;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformAppear extends PlatformController {
	public override function new( s:PlatformMoveBasic = null ) {
		super();
		if ( s != null )
			s.setControl( this );
		setObject();
	}
	public override function setObject() {
		if ( slave != null ) {
			slave.visible = false;
			slave.ignore = true;
		}
	}
	public override function receive_signal( sig:Int ) {
		slave.visible = true;
		slave.ignore = false;
	}
}