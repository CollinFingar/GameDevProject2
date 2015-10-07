package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;

/**
 * ...
 * @author ...
 */
class Collectible extends FlxSprite
{
    public static inline var RUN_SPEED:Int =  200;
    var parent:PlayState;
    
	public var score:Int = 10;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X-10, Y-10);
        makeGraphic(30, 30, FlxColor.GOLDEN);
        parent = Parent;
        updateHitbox();
    }
    
    public override function update():Void {
        super.update();
    }

	override public function destroy():Void {
		super.destroy();
	}
    
}
