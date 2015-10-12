package platforms;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformMoveBasic extends PlatformTiles {
	var controller:PlatformController;
	var hspd:Float;
	var vspd:Float;
	
	public override function new( par:platforms.PlatformGroup, n:String, csv:String, nx:Int = 0, ny:Int = 0 ) {
		super( par, n, csv, nx, ny );
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
}