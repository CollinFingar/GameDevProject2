package source.ui;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.FlxCamera;

using flixel.util.FlxSpriteUtil;

enum CUTSCENE_STATE {
	CUTSCENE_OPENED;
	CUTSCENE_OPENING;
	CUTSCENE_CLOSING;
	CUTSCENE_CLOSED;
}

class CutScene extends FlxSubState {
	
	var state:CUTSCENE_STATE;
	var upper:FlxSprite;
	var lower:FlxSprite;
	var height:Int;
	
	var porth:Int;
	var portrait:FlxSprite;
	var saying:FlxText;
	var said:FlxText;
	var indexA:Int; // index in dialogue
	var indexB:Int; // index in sub-dialogue
	var indexC:Int; // character index in text
	var buffer:Float;
	var wrtspeed:Float;
	
	var portraits:Map<String,FlxSprite>;
	var dialogue:Array<Array<String>>;
	
	public override function new( par:FlxState, h:Float = 0.2 ) {
		super();
		
		height = cast(cast(FlxG.height, Float) * h, Int);
		porth = height - 32;
		
		upper = new FlxSprite( 0, 0 );
		lower = new FlxSprite( 0, FlxG.height - height );
		portrait = new FlxSprite( 16, FlxG.height - porth - 16 );
		
		saying = new FlxText( porth + 32, FlxG.height - porth, FlxG.width - porth - 120, "Saying" );
		said = new FlxText( porth + 32, FlxG.height - porth + 40, FlxG.width - porth - 120, "Said words words words words words words words" );
		
		upper.makeGraphic( FlxG.width, height, FlxColor.BLACK );
		upper.origin.set( 0, 0 );
		
		lower.makeGraphic( FlxG.width, height+2, FlxColor.BLACK );
		lower.origin.set( 0, height );
		
		portrait.makeGraphic( porth, porth, 0xFFEEBC1D );
		portrait.drawRect( 16, 16, porth - 32, porth - 32, 0xFFDDDDDD );
		
		saying.size = 32;
		said.size = 16;
		
		upper.scale.y = 0;
		lower.scale.y = 0;
		
		indexA = 0;
		indexB = 0;
		indexC = 0;
		wrtspeed = 1.2;
		buffer = 0;
		
		dialogue = new Array<Array<String>>();
		portraits = new Map<String,FlxSprite>();
		
		state = CUTSCENE_CLOSED;
		
		add( upper );
		add( lower );
		add( portrait );
		add( saying );
		add( said );
		
		par.add( this );
		
		hide_dialogue();
		
	}
	public function add_character( name:String, img:FlxSprite ):Void {
		portraits[name] = img;
	}
	public function add_dialogue( name:String, txt:String ):Void {
		if ( dialogue[dialogue.length - 1][0] == name ) {
			dialogue[dialogue.length - 1].push( txt );
		} else
			dialogue.push( [name, txt] );
	}
	
	private function show_dialogue():Void {
		portrait.alpha = 1.0;
		saying.alpha = 1.0;
		said.alpha = 1.0;
	}
	private function hide_dialogue():Void {
		portrait.alpha = 0.0;
		saying.alpha = 0.0;
		said.alpha = 0.0;
	}
	private function write_text():Void {
		
	}
	
	public function show():Void {
		switch ( state ) {
			case CUTSCENE_CLOSED | CUTSCENE_CLOSING:
				state = CUTSCENE_OPENING;
			case CUTSCENE_OPENED | CUTSCENE_OPENING:
		}
	}
	public function hide():Void {
		switch ( state ) {
			case CUTSCENE_OPENED | CUTSCENE_OPENING:
				state = CUTSCENE_CLOSING;
				hide_dialogue();
			case CUTSCENE_CLOSED | CUTSCENE_CLOSING:
		}
	}
	
	public function is_opening():Bool {
		return ( state == CUTSCENE_OPENED || state == CUTSCENE_OPENING );
	}
	public function is_closing():Bool {
		return ( state == CUTSCENE_CLOSED || state == CUTSCENE_CLOSING );
	}
	
	public function change():Void {
		if ( is_opening() )
			hide();
		else
			show();
	}
	
	public override function update():Void {
		super.update();
		switch( state ) {
			case CUTSCENE_CLOSED:
			case CUTSCENE_OPENING:
				upper.scale.y += ( 1 - upper.scale.y ) / 2;
				lower.scale.y += ( 1 - lower.scale.y ) / 2;
				if ( upper.scale.y >= 0.99 ) {
					upper.scale.y = 1;
					lower.scale.y = 1;
					state = CUTSCENE_OPENED;
					if ( dialogue.length != 0 )
						show_dialogue();
				}
			case CUTSCENE_CLOSING:
				upper.scale.y -= ( upper.scale.y ) / 2;
				lower.scale.y -= ( lower.scale.y ) / 2;
				if ( upper.scale.y >= 0.99 ) {
					upper.scale.y = 1;
					lower.scale.y = 1;
					state = CUTSCENE_CLOSED;
				}
			case CUTSCENE_OPENED:
				write_text();
		}
	}
}