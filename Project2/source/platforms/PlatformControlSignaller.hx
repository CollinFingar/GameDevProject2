package platforms;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import openfl.Assets;

class PlatformControlSignaller extends FlxSprite {
	var parent:PlatformGroup;
	var target:PlatformController;
	
	public override function new( par:PlatformGroup, nx:Float, ny:Float, spr:String, ctrl:PlatformController = null ) {
		super( nx, ny );
		loadGraphic(spr);
		parent = par;
		parent.parent.add( this );
		target = ctrl;
	}
	public function setTarget( targ:PlatformController = null ) {
		target = targ;
	}
	public function send_signal( sig:Int ) {
		if ( target != null )
			target.receive_signal( sig );
	}
}