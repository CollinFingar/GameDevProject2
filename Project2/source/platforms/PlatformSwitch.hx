package platforms;
;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import openfl.Assets;

class PlatformSwitch extends FlxSprite {
	var target:PlatformController;
	
	public override function new( nx:Float, ny:Float, spr:FlxSprite, ctrl:PlatformController = null ) {
		super( nx, ny );
		loadGraphicFromSprite( spr );
		target = ctrl;
	}
	public function setTarget( targ:PlatformController = null ) {
		target = targ;
	}
	public function send_signal( sig:Int ) {
		if ( target != null )
			taret.receive_signal( sig );
	}
}