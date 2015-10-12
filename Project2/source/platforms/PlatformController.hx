package platforms;

import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformController extends FlxBasic {
	public var slave:PlatformMoveBasic;
	
	public override function new() {
		super();
		slave = null;
	}
	public function setObject():Void {
		return;
	}
	public function control():Void {
		return;
	}
	public function receive_signal( sig:Int ) {
		return;
	}
}