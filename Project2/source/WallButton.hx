package platforms;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import platforms.PlatformControlSignaller;
import openfl.Assets;

class WallButton extends PlatformControlSignaller {
	public function send_signal( sig:Int ) {
		if ( target != null )
			target.receive_signal( sig );
	}
}