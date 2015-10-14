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
	var pressed:Bool = false;
	
	public override function new( par:PlatformGroup, nx:Float, ny:Float, ctrl:PlatformController = null ) {
		super( nx, ny );
		loadGraphic("assets/images/misc/switch_UNPRESSED.png", false);
		
		parent = par;
		parent.parent.add( this );
		target = ctrl;
	}
	public function setTarget( targ:PlatformController = null ) {
		target = targ;
	}
	public function send_signal( sig:Int ) {
		if ( !pressed && target != null ) {
			loadGraphic("assets/images/misc/switchPRESS_121x120_16fps_strip3.png", true, 121, 120);
			animation.add( "press", [0, 1, 2], 16, false );
			animation.play( "press" );
			setSize( width / 2, height / 2 );
			offset.set( width / 2, height / 2);
			target.receive_signal( sig );
			pressed = true;
			trace( "SIGNAL SET!" );
		}
	}
	
	static public function makeController( ps:PlayState, tm:PlatformGroup, str:String, str2:String ) {
		var tmap:FlxTilemap = new FlxTilemap();
		tmap.loadMap(Assets.getText(str), "assets/images/tiles1.png", 64, 64);
		
		var what = tmap.getTileCoords( 48, false );
		var when = tmap.getTileCoords( 1, false );
		
		var pcs = new PlatformControlSignaller( tm, what[0].x, what[0].y );
		ps.switches.push( pcs );
		ps.add( pcs );
		
		if ( what[0].x < when[0].x ) {
			pcs.flipX = false;
		} else {
			pcs.flipX = true;
		}
		
		var plat = new PlatformMoveBasic( tm, "Switch", str2, [18] );
		pcs.setTarget( new PlatformAppear( plat ) );
	}
}