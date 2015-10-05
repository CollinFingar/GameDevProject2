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
...
