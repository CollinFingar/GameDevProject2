package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import lime.project.Platform;
import platforms.PlatformTiles;

class MoveBase extends FlxSprite
{
	// platform to which the object is bound
	// NULL if the player is not bound to an object
	var master:platforms.PlatformTiles;
	
	// when the movable leaves the platform, an echo of the
	// platforms speed remains
	// even if the platform changes speeds before the movable
	// finds a new master, the echo will be constant
	public var echo:FlxPoint;
	public var ignore:Bool = false;
	
	public override function new( X:Float, Y:Float ) {
		super( X, Y );
		master = null;
		echo = new FlxPoint();
	}
	public function assignBase( mov:platforms.PlatformTiles = null ) {
		if ( master != null )
			master.setSlot( null );
		master = mov;
		if ( master != null ) {
			//color = FlxColor.RED;
			master.setSlot( this );
		} //else
			//color = FlxColor.WHITE;
	}
	public function getBase():PlatformTiles {
		return master;
	}
	public function shouldCollide( other:PlatformTiles ):Bool {
		return true;
	}
	public function collision( other:platforms.PlatformTiles, xs:Bool, ys:Bool ):Void {
		return;
	}
	public function postCollision():Void {
		return;
	}
}
