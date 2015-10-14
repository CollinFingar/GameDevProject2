package;

import flixel.FlxG;
import source.ui.CutScene;

class Script {
	var parent:PlayState;
	var cs:CutScene;
	
	var waitduration:Float;
	var waitingnow:Bool = false;
	var writingscene:Bool = false;
	var actors:Array<Actor> = [];
	var actions:Array<Dynamic> = [];
	public var index:Int = -2;
	
	function action( a:Actor, fname:String, args:Array<Dynamic> = null ):Void {
		actions.push( [ a, fname, args ] );
	}
	function talk( n:String, sn:String, txt:String ):Void {
		actions.push( ["talk",n,sn,txt] );
	}
	function music( fname:String, del:Float, rep:Bool ):Void {
		actions.push( ["music",fname,del,rep] );
	}
	function silence():Void {
		actions.push( ["silent"] );
	}
	function wait( s:Float ):Void {
		actions.push( ["wait",s] );
	}
	function begin_script():Void {
		WillG.speechBubblesActive = false;
		cs.show();
		for ( act in actors )
			act.passToScript();
		index = 0;
		waitingnow = false;
		writingscene = false;
	}
	function end_script():Void {
		for ( act in actors )
			act.passToGame();
		index = -2;
		cs.hide();
		WillG.speechBubblesActive = true;
	}
	public function reset() {
		index = -1;
	}
	// write script
	public function new( par:PlayState, ccs:CutScene, arr:Array<Actor> ) {
		parent = par;
		cs = ccs;
		actors = arr;
	}
	public function next():Void {
		if ( index == -2 )
			return;
		else if ( index == -1 )
			begin_script(); // capture actors
		else if ( index == actions.length )
			end_script();
		else {
			if ( actions[index].length != 3 ) {
				if ( actions[index][0] == "talk" ) {
					if ( writingscene ) {
						if ( FlxG.keys.anyJustPressed(["ENTER"]) ) {
							if ( cs.next_ready() ) {
								index ++ ;
								writingscene = false;
							} else {
								cs.flush();
							}
						}
					} else {
						cs.go_next( actions[index][1],
									actions[index][2],
									actions[index][3] );
						writingscene = true;
					}
				} else if ( actions[index][0] == "music" ) {
					FlxG.sound.playMusic( actions[index][1], actions[index][2], actions[index][3] );
					index ++ ;
				} else if ( actions[index][0] == "silent" ) {
					cs.hide_dialogue();
					index ++ ;
				} else if ( actions[index][0] == "wait" ) {
					if ( waitingnow ) {
						waitduration += FlxG.elapsed;
						if ( waitduration >= actions[index][1] ) {
							waitingnow = false;
							index ++ ;
						}
					} else {
						waitduration = 0;
						waitingnow = true;
					}
				}
			} else {
				Reflect.callMethod( actions[index][0], 
									Reflect.getProperty(actions[index][0],
														actions[index][1]), 
														actions[index][2]);
				if ( actions[index][0].ready() ) {
					index ++ ;
				}
			}
		}
	}
	public function start():Void {
		if ( index == -2 )
			index = -1;
	}
	public function update():Void {
		next();
	}
}