package;

import source.ui.CutScene;

class ScriptLvl1 extends Script {
	public override function new( par:PlayState, ccs:CutScene, arr:Array<Actor> ) {
		super( par, ccs, arr );
		
		var princess = arr[0];
		var prince = arr[1];
		var cage = arr[2];
		var cloud = arr[3];
		
		action( prince, "move", ["right", 320, 1.5] );
		
		wait( 1.5 );
		
		action( prince, "impulse", ["right", 800] );
		action( prince, "impulse", ["up", 1000] );
		
		wait( 0.5 );
		
		talk( "Knight", "normal", "Princess Licia, I've come to rescue you from this tower!" );
		
		action( cage, "signal", [0] );
		
		wait( 0.2 );
		
		action( princess, "signal", [Player.SIG_PRINCESS_AWAKE] );
		
		talk( "Princess", "neutral", "Well, it's about time SOMEONE came. Who are you with? The Royal Army?" );
		talk( "Knight", "normal", "No, Princess. I came here on my own accord, so you would have my hand in marriage." );
		talk( "Princess", "uhh", "Marriage? MARRIAGE? You do realize that we're going to have to fight our way out of this tower?" );
		talk( "Knight", "normal", "That should be no problem at all! I fought my way up here for you, I can fight my way out!" );
		talk( "Princess", "grr", "For ME? No. You fought your way up here so I would have to marry you." );
		talk( "Knight", "normal", "Well, isn't that how it goes? The Knight climbs the tower. The Knight rescues the Princess. They escape and get married." );
		talk( "Princess", "grr", "You really expect me to marry some self-centered jerk who is only in this for himself?" );
		talk( "Knight", "normal", "Of course! That's how it goes!" );
		talk( "Princess", "neutral", "Well, okay then." );
		
		silence();
		
		action( princess, "signal", [Player.SIG_PRINCESS_ANGRY] );
		
		wait( 2.0 );
		
		action( princess, "move", ["left", 300, 0.25] );
		
		action( cloud, "signal", [0] );
		action( princess, "signal", [Player.SIG_PRINCESS_DONE] );
		action( prince, "signal", [0] );
		
		wait( 2 );
		
		talk( "Princess", "neutral", "Ugh, men. They always think that just because they're saving Princesses, that they have to elope. They never think about how we feel." );
		talk( "Princess", "neutral", "WHATEVER. I'm out of this place." );
	}
}