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

using flixel.util.FlxSpriteUtil;

enum SPEECH_STATE {
	SPEECH_ERASING;
	SPEECH_STABLE_WRITTEN;
	SPEECH_WRITING;
	SPEECH_GROWING;
	SPEECH_STABLE_CLOSE;
	SPEECH_SHRINKING;
}

class SpeechBubble extends FlxBasic {
	
	var state:SPEECH_STATE;
	
	public var bubble:FlxSprite;
	var text:FlxText;
	
	var srctext:String;
	var index:Int;
	var buffer:Float;
	var speed:Float;
	var writespd:Float;
	
	public override function new( par:FlxState, pos:FlxPoint, w:Int, h:Int, txt:String, spd:Float = 0.1, wrtspd:Float = 1.2 ) {
		super();
		
		bubble = new FlxSprite( pos.x, pos.y );
		text = new FlxText( pos.x + 16, pos.y + 16, w - 32, "" );
		
		state = SPEECH_STABLE_CLOSE;
		speed = spd;
		writespd = wrtspd;
		srctext = txt;
		buffer = 0;
		index = 0;
		
        bubble.makeGraphic( w, h, FlxColor.TRANSPARENT );
		bubble.drawRoundRect( 0, 0, w, h, 16, 16, FlxColor.WHITE );
		
		bubble.alpha = 0;
		bubble.scale.set( 0, 0 );
		bubble.origin.set( 0, h );
		
		text.size = 16;
		text.color = FlxColor.BLACK;
		
		par.add( bubble );
		par.add( text );
		par.add( this );
	}
	
	private function grow():Void {
		if ( bubble.scale.x <= 1 - speed ) {
			bubble.scale.x += speed;
			bubble.scale.y += speed; 
			bubble.alpha = bubble.scale.x * 2;
		} else {
			bubble.scale.set( 1, 1 );
			buffer = 0;
			state = SPEECH_WRITING;
		}
	}
	private function shrink():Void {
		if ( bubble.scale.x >= speed ) {
			bubble.scale.x -= speed;
			bubble.scale.y -= speed;
			bubble.alpha = bubble.scale.x * 2;
		} else {
			bubble.scale.set( 0, 0 );
			state = SPEECH_STABLE_CLOSE;
		}
	}
	private function write():Void {
		buffer += writespd;
		while ( buffer > 1 ) {
			index += 1;
			buffer -= 1;
		}
		if ( index >= srctext.length ) {
			index = srctext.length;
			text.text = srctext;
			buffer = 0;
			state = SPEECH_STABLE_WRITTEN;
		} else
			text.text = srctext.substring( 0, index );
	}
	private function erase():Void {
		buffer += writespd;
		while ( buffer > 1 ) {
			index -= 1;
			buffer -= 1;
		}
		if ( index <= 0 ) {
			index = 0;
			text.text = "";
			buffer = 0;
			state = SPEECH_SHRINKING;
		} else
			text.text = srctext.substring( 0, index );
	}
	
	public function open():Void {
		switch ( state ) {
			case SPEECH_STABLE_CLOSE | SPEECH_SHRINKING :
				state = SPEECH_GROWING;
			case SPEECH_ERASING :
				state = SPEECH_WRITING;
			case SPEECH_WRITING | SPEECH_STABLE_WRITTEN | SPEECH_GROWING:
		}
	}
	public function close():Void {
		switch ( state ) {
			case SPEECH_STABLE_WRITTEN | SPEECH_WRITING:
				state = SPEECH_ERASING;
			case SPEECH_GROWING:
				state = SPEECH_SHRINKING;
			case SPEECH_ERASING | SPEECH_STABLE_CLOSE | SPEECH_SHRINKING:
		}
	}
	public function is_opening():Bool {
		return ( state == SPEECH_WRITING || 
				 state == SPEECH_GROWING ||
				 state == SPEECH_STABLE_WRITTEN );
	}
	public function is_closing():Bool {
		return ( state == SPEECH_ERASING || 
				 state == SPEECH_SHRINKING ||
				 state == SPEECH_STABLE_CLOSE );
	}
	public function change():Void {
		if ( is_opening() )
			close();
		else
			open();
	}
	
	public override function update():Void {
		super.update();
		switch ( state ) {
			case SPEECH_STABLE_CLOSE | SPEECH_STABLE_WRITTEN:
			case SPEECH_GROWING:
				grow();
			case SPEECH_SHRINKING:
				shrink();
			case SPEECH_WRITING:
				write();
			case SPEECH_ERASING:
				erase();
		}
	}
}
