package platforms;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

class PlatformGroup extends FlxGroup {
	public var tilepng:String;
	public var collide:Array<Int>;
	public var parent:FlxState;
	
	public override function new( p:FlxState, tpng:String, col:Array<Int> ) {
		super();
		tilepng = tpng;
		collide = col;
		parent = p;
		parent.add( this );
	}
	public function collisionCheck( obj:MoveBase ):Void {
		callAll( "collisionCheck", [obj] );
		obj.postCollision();
	}
	public override function update():Void { }
	public function override_update():Void {
		super.update();
	}
}