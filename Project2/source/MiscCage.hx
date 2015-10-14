package;
import flixel.FlxSprite;

class MiscCageFront extends FlxSprite implements Actor {
	public var scr:Script;
	var bg:FlxSprite;
	var newAction:Bool = true;
	var initY:Float;
	
	public override function new( X:Float, Y:Float, par:PlayState, b:FlxSprite ) {
		super(X, Y);
		loadGraphic( "assets/images/enemies/cageFRONT.png" );
		bg = b;
		par.add( this );
	}
	public override function update():Void {
		super.update();
		bg.x = x;
		bg.y = y;
		bg.alpha = alpha;
	}
	
	// enter and exit the script
	public function passToScript():Void { }
	public function passToGame():Void { } 
	
	// control movement
	public function move( direc:String, amount:Int, time:Float ):Void {
		
	}
	public function moveTo( direc:String, amount:Int, time:Float ):Void {
		
	}
	public function impulse( direc:String, amount:Int ):Void {
		
	}
	public function signal( sig:Int ):Void {
		if ( newAction ) {
			initY = y;
			newAction = false;
			velocity.y = -250;
		}
		if ( initY - y  >= 400 ) {
			velocity.y = 0;
			newAction = true;
		}
		alpha -= 0.01;
	}
	
	// returns false if the movement is incomplete
	// returns true if the script may proceed
	public function ready():Bool {
		return newAction;
	}
}