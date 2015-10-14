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

/* 
 * USAGE
  	var Joe = new FlxSprite( 0, 0 );
	var Mike = new FlxSprite( 0, 0 );
	
	Joe.makeGraphic( 120, 80, FlxColor.GREEN );
	Mike.makeGraphic( 70, 130, FlxColor.RED );
	
	cs = new CutScene( this );
	
	cs.add_character( "Joe", Joe );
	cs.add_character( "Mike", Mike );
	
	cs.add_dialogue( "Joe",  "So what are we doing" );
	cs.add_dialogue( "Mike", "I don't know" );
	cs.add_dialogue( "Mike", "Ask me about it later" );
	cs.add_dialogue( "Joe",  "Yeah okay sure whatever" );
	
	add( Joe );
	add( Mike );
 */

enum CUTSCENE_STATE {
	CUTSCENE_OPENED;
	CUTSCENE_OPENING;
	CUTSCENE_CLOSING;
	CUTSCENE_CLOSED;
}

class CutScene extends FlxSubState {
	
	var showing:Bool;
	var state:CUTSCENE_STATE;
	var upper:FlxSprite;
	var lower:FlxSprite;
	var height:Int;
	
	var porth:Int;
	var portrait:FlxSprite;
	var saying:FlxText;
	var said:FlxText;
	var indexA:Int; // index in dialogue
	var indexB:Int; // character index in text
	var wait_end:Bool; // wait at the end of a text segment
	var buffer:Float;
	var wrtspeed:Float;
	
	var portraits:Map<String,Map<String,FlxSprite>>;
	var characters:Array<String>;
	var expressions:Array<String>;
	var dialogue:Array<String>;
	
	public override function new( par:FlxState, h:Float = 0.2 ) {
		super();
		
		height = cast(cast(FlxG.height, Float) * h, Int);
		porth = height - 32;
		
		upper = new FlxSprite( 0, 0 );
		lower = new FlxSprite( 0, FlxG.height - height );
		portrait = new FlxSprite( 16, FlxG.height - porth - 16 );
		
		saying = new FlxText( porth + 32, FlxG.height - porth, FlxG.width - porth - 120, "Salty" );
		saying.color = FlxColor.WHITE;
		saying.scrollFactor.set( 0, 0 );
		said = new FlxText( porth + 32, FlxG.height - porth + 40, FlxG.width - porth - 120, "... so salty ..." );
		said.color = FlxColor.WHITE;
		said.scrollFactor.set( 0, 0 );
		
		upper.makeGraphic( FlxG.width, height, FlxColor.BLACK );
		upper.origin.set( 0, 0 );
		upper.scrollFactor.set( 0, 0 );
		
		lower.makeGraphic( FlxG.width, height+2, FlxColor.BLACK );
		lower.origin.set( 0, height );
		lower.scrollFactor.set( 0, 0 );
		
		portrait.makeGraphic( porth, porth, 0xFFEEBC1D );
		portrait.drawRect( 16, 16, porth - 32, porth - 32, 0xFFDDDDDD );
		portrait.scrollFactor.set( 0, 0 );
		
		saying.size = 32;
		said.size = 16;
		
		upper.scale.y = 0;
		lower.scale.y = 0;
		
		indexA = 0;
		indexB = 0;
		wrtspeed = 1.2;
		buffer = 0.0;
		wait_end = true;
		
		characters = new Array<String>();
		expressions = new Array<String>();
		dialogue = new Array<String>();
		portraits = new Map<String,Map<String,FlxSprite>>();
		
		state = CUTSCENE_CLOSED;
		
		add( upper );
		add( lower );
		add( portrait );
		add( saying );
		add( said );
		
		par.add( this );
		
		hide_dialogue();
		hide();
		
	}
	public function add_character( name:String, subname:String, img:FlxSprite ):Void {
		if ( portraits[name] == null )
			portraits[name] = new Map<String,FlxSprite>();
		portraits[name][subname] = img;
		
		img.x = 16 + porth / 2 - img.width / 2;
		img.y = FlxG.height - img.height / 2 - porth / 2 - 16;
		
		img.alpha = 0;
		
		var scx = cast(porth - 32, Float) / cast(img.width, Float);
		var scy = cast(porth - 32, Float) / cast(img.height, Float);
		
		img.scale.set( Math.min(scx, scy), Math.min(scx, scy) );
		
		img.scrollFactor.set( 0, 0 );
	}
	public function add_dialogue( name:String, subname:String, txt:String ):Void {
		characters.push( name );
		expressions.push( subname );
		dialogue.push( txt );
	}
	
	function fetch(n:Int):FlxSprite {
		return portraits[characters[n]][expressions[n]];
	}
	public function show_dialogue():Void {
		portrait.alpha = 1.0;
		saying.alpha = 1.0;
		said.alpha = 1.0;
		saying.text = "";
		said.text = "";
		if ( indexA < characters.length )
			fetch(indexA).alpha = 1.0;
	}
	public function hide_dialogue():Void {
		portrait.alpha = 0.0;
		saying.alpha = 0.0;
		said.alpha = 0.0;
		for ( i in 0...indexA ) {
			if ( i < characters.length ) {
				fetch(i).alpha = 0.0;
			}
		}
	}
	private function write_text():Void {
		if ( !wait_end ) {
			if ( indexA < dialogue.length ) {
				saying.text = characters[indexA];
				if ( indexA > 0 )
					fetch(indexA-1).alpha = 0;
				fetch(indexA).alpha = 1;
				
				var txt:String = dialogue[indexA];
				if ( indexB < txt.length ) {
					buffer += wrtspeed;
					while ( buffer > 1 ) {
						buffer -- ;
						indexB ++ ;
					}
					said.text = txt.substring( 0, indexB );
				} else {
					wait_end = true;
					indexB = 0;
					indexA ++ ;
				}
			} else {
				if ( indexA > 0 ) {
					trace( characters );
					trace( indexA );
					trace( characters[indexA - 1] );
					fetch(indexA - 1).alpha = 0;
				}
				buffer = 0;
				hide();
			}
		}
	}
	
	public function show():Void {
		if ( !showing ) {
			indexA = 0;
			indexB = 0;
			showing = true;
			show_dialogue();
		}
		switch ( state ) {
			case CUTSCENE_CLOSED | CUTSCENE_CLOSING:
				state = CUTSCENE_OPENING;
			case CUTSCENE_OPENED | CUTSCENE_OPENING:
		}
	}
	public function hide():Void {
		if ( showing ) {
			showing = false;
			hide_dialogue();
		}
		switch ( state ) {
			case CUTSCENE_OPENED | CUTSCENE_OPENING:
				state = CUTSCENE_CLOSING;
			case CUTSCENE_CLOSED | CUTSCENE_CLOSING:
		}
	}
	
	public function is_opening():Bool {
		return ( state == CUTSCENE_OPENED || state == CUTSCENE_OPENING );
	}
	public function is_closing():Bool {
		return ( state == CUTSCENE_CLOSED || state == CUTSCENE_CLOSING );
	}
	
	public function next_ready():Bool {
		return wait_end;
	}
	public function flush():Void {
		trace( "CALL flush" );
		if ( indexA < characters.length )
			indexB = dialogue[indexA].length - 1;
	}
	public function go_next():Void {
		trace( "CALL go_next" );
		if ( wait_end ) {
			if ( saying.alpha == 0 )
				show_dialogue();
			wait_end = false;
		} else {
			indexA ++ ;
			indexB = 0;
		}
	}
	public function change():Void {
		if ( state == CUTSCENE_OPENED ) {
			if ( wait_end ) {
				go_next();
			} else {
				flush();
			}
		} else if ( state == CUTSCENE_OPENING )
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
