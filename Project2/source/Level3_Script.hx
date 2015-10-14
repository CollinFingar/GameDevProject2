package;

import flixel.FlxG;
import source.ui.CutScene;

class ScriptLvl3 extends Script {
	public override function new( par:PlayState, ccs:CutScene, arr:Array<Actor> ) {
		super( par, ccs, arr );
		
		var princess = arr[0];
		var prince = arr[1];
		var cage = arr[2];
		var cloud = arr[3];
		
		silence();
		
	}
}