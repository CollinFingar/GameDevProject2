package;

interface Actor {
	public var scr:Script;
	
	// enter and exit the script
	public function passToScript():Void;	// use the script to control the actor
	public function passToGame():Void;		// resets last escape, begin from beginning
	
	// control movement
	public function move( direc:String, amount:Int, time:Float ):Void;
	public function moveTo( direc:String, amount:Int, time:Float ):Void;
	public function impulse( direc:String, amount:Int ):Void;
	public function signal( sig:Int ):Void;
	
	// returns false if the movement is incomplete
	// returns true if the script may proceed
	public function ready():Bool;
}