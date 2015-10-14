package;

import flixel.FlxG;
import source.ui.CutScene;

class ScriptLvl3 extends Script {
	public override function end_script():Void {
		trace( "EV" );
		FlxG.camera.color -= 0x00030303;
		trace( "ALPHA " + FlxG.camera.alpha );
		if ( FlxG.camera.color == 0 ) {
			FlxG.switchState(new YouWinState());
		}
	}
	public override function new( par:PlayState, ccs:CutScene, arr:Array<Actor> ) {
		super( par, ccs, arr );
		
		var princess = arr[0];
		var prince = arr[1];
		var cravin = arr[2];
		
		silence();
		
		action( princess, "move", ["left", 700, 2] );
		action( princess, "signal", [10] );
		
		wait( 1.0 );
		
		action( prince, "move", ["right",0,0] );
		action( prince, "signal", [1] );
		
		wait( 0.5 );
		
		action( princess, "move", ["right", 0, 0] );
		talk( "Knight", "normal", "Miss Licia!" );
		
		talk( "Princess Licia", "neutral", "That's 'Your Royal Highness'." );
		talk( "Knight", "normal", "M'lady Licia, I came here to rescue a ravishing maiden suiting one of my unabashed bravery and unwavering stature. I shan't leave without what I was promised!" );

		talk( "Princess Licia", "neutral", "Promised?" );
		
		talk( "Knight", "normal", "Er... Well." );

		shake( .01, .5 );
		talk( "King Cravin", "only", "Contemptible blithering knight! Our end of the deal was held. The princess' kidnap was orchestrated perfectly. We can't imagine how you befouled the plan so thoroughly. Control of her kingdom was within Our grasp!" );

		talk( "Knight", "normal", "Oh great King Cravin of the Dark Tower, uh, sir. The maiden knows not her place and would not grace her rescuer with holy matrimony! I could not become heir and honour the bargain. It was impossible!" );

		talk( "Princess Licia", "neutral", "Marriage for a kingdom? What lecherous nonsense assaults mine virgin ears!? Speak not of such treacherous plans and bargains again, get ye gone, and you may yet not spend the rest of your days rotting in a dungeon, scum." );
		
		shake( .01, .5 );
		talk( "King Cravin", "only", "That we had known this boy's incompetence, your chains would have tightened tenfold." );

		talk( "Princess Licia", "neutral", "If there be blood yet to spill, show thine self and face me cur!" );

		shake( .01, .5 );
		talk( "King Cravin", "only", "Art thou KIDDING? We are a king, not some common barbarian. Do you think I wait around all day for brave heroes to topple my castles and steal my things? I­ uh, WE have people for this. Boy, do what thou wilt, We wash Our hands of this bilge." );

		talk( "Knight", "normal", "I deserve a great destiny, and I shall fight for it if I must." );

		silence();
		action( prince, "move", ["left", 100, 0.5] );

		talk( "Princess Licia", "neutral", "I could buy your hometown and turn it to tracts of smoldering garbage. Not to mention, I already defeated Cravin's entire craven army..." );

		talk( "Princess Licia", "neutral", "In a DRESS!" );

		talk( "Knight", "normal", "... Th­th­that is to say... I'll live to fight for my destiny another day!" );
		
		silence();
		
		action( prince, "move", ["right", 0, 0] );
		wait( 0.25 );
		action( prince, "move", ["right", 800, 4] );
		
		wait( 0.25 );
		
	}
}