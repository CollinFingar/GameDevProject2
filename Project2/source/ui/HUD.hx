package source.ui;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.FlxCamera;

class HUD extends FlxSubState {
	
	var heart:Array<FlxSprite>;
	var textbox:FlxText;
	var healthlab:FlxText;
	var scorelab:FlxText;
	
	var health:Int;
	var score:Int;
	
	public override function new( par:FlxState, hcount:Int, htemplate:FlxSprite, sscore:Int ) {
		super();
		
		health = hcount;
		score = sscore;
		
		heart = new Array<FlxSprite>();
		for ( i in 0...hcount ) {
			var tmp:FlxSprite = htemplate.clone();
			tmp.scrollFactor.set( 0, 0 );
			tmp.x = 16 * (i + 1) + htemplate.width * i;
			tmp.y = 16;
			add( tmp );
			heart.push( tmp );
		}
		healthlab = new FlxText( 16, 32 + htemplate.height, 300, "Health" );
		healthlab.size = 32;
		healthlab.scrollFactor.set( 0, 0 );
		add( healthlab );
		
		textbox = new FlxText( 16, 16, FlxG.width-32, Std.string( score ) );
		textbox.size = htemplate.height;
		textbox.alignment = "right";
		textbox.scrollFactor.set( 0, 0 );
		add( textbox );
		
		scorelab = new FlxText( 16, 32 + htemplate.height, FlxG.width - 32, "Score" );
		scorelab.size = 32;
		scorelab.alignment = "right";
		scorelab.scrollFactor.set( 0, 0 );
		add( scorelab );
		
		par.add( this );
	}
	
	public function AddScore( value:Int ) {
		score -= value;
		textbox.text = Std.string( score );
	}
	public function setHealth( amt:Int ) {
		// Cannot take damage outside of range
		if ( amt < 0 )
			amt = 0;
		if ( amt > heart.length )
			amt = heart.length;
		
		// Heal or Damage
		if ( health < amt ) {
			for ( i in health...amt )
				heart[i].alpha = 1;
		} else if ( health > amt ) {
			for ( i in amt...health )
				heart[i].alpha = 0;
		}
		
		// Set new health value
		health = amt;
	}
	public function getHealth():Int {
		return health;
	}
	public function heal( amt:Int ) {
		setHealth( health + amt );
	}
	public function damage( amt:Int ) {
		setHealth( health - amt );
	}
}