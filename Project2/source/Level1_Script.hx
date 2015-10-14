package;

import flixel.FlxG;
import source.ui.CutScene;

class ScriptLvl1 extends Script {
	public override function new( par:PlayState, ccs:CutScene, arr:Array<Actor> ) {
		super( par, ccs, arr );
		
		var princess = arr[0];
		var prince = arr[1];
		var cage = arr[2];
		var cloud = arr[3];
		
		silence();
		
		action( prince, "move", ["right", 320, 1.5] );
		
		wait( 1.5 );
		
		action( prince, "impulse", ["right", 800] );
		action( prince, "impulse", ["up", 1000] );
		
		wait( 0.5 );
		
		talk( "Knight", "normal", "Princess Licia, I've come to rescue you from this tower!" );
		
		silence();
		action( cage, "signal", [0] );
		
		wait( 0.2 );
		
		action( princess, "signal", [Player.SIG_PRINCESS_AWAKE] );
		
		talk( "Princess", "neutral", "Well, it's about time SOMEONE came. Who are you with? The Royal Army?" );
		talk( "Knight", "normal", "No, Princess. I have come from a faraway land of my own accord, to have the beutiful maiden's hand in marriage." );
		talk( "Princess", "uhh", "Marriage? MARRIAGE? You do realize that we're going to have to fight our way out of this tower?" );
		talk( "Knight", "normal", "That should be no problem at all! I fought my way up here for you, I can fight my way out!" );
		talk( "Princess", "grr", "For ME, huh!? I am royalty! How dare you speak to me thusly. On whose divine authority do I owe you anything, sir knight? " );
		talk( "Knight", "normal", "Well, isn't that how it goes? The Knight climbs the tower. The Knight rescues the Princess. They escape and get married." );
		talk( "Princess", "grr", "Are you serious? You really expect me to just walk off with you, don't you? Well, come here and let me see the face of my BRAVE savior." );
		talk( "Knight", "normal", "But of course!" );
		
		silence();
		
		action( princess, "signal", [Player.SIG_PRINCESS_ANGRY] );
		
		wait( 2.0 );
		music( "assets/music/towerbgm.ogg", .2, true );	
		
		action( princess, "move", ["left", 300, 0.25] );
		
		action( cloud, "signal", [0] );
		action( princess, "signal", [Player.SIG_PRINCESS_DONE] );
		action( prince, "signal", [0] );
		
		wait( 2 );
		
		talk( "Princess", "neutral", "Marriage, pah! This second rate baffoon couldn't hope to conquer a shetland pony, much less my kingdom." );
		talk( "Princess", "neutral", "Enough of this drudgery. I'm out of this place." );
	}
}