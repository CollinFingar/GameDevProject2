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
class Heart extends FlxSprite
{
    public static inline var RUN_SPEED:Int =  200;
    var parent:PlayState;
    
	public var amount:Int = 1;
    
    public function new(X:Float=0, Y:Float=0, Parent:PlayState) 
    {
        super(X - 20, Y - 50);
		
        loadGraphic("assets/images/heart.png", false);
			
		//animation.add( "spin",  [0, 1, 2, 3, 4, 5, 6, 7], 14, true);
		//animation.play("spin", false);
		
		//makeGraphic(40, 40, FlxColor.CRIMSON);
		
		//scale.set(.5, .5);
        //setSize(width / 4, height / 4);
		//offset.set(width*1.5, height);
		
        parent = Parent;
        //updateHitbox();
		
		
    }
    
    public override function update():Void {
        super.update();
    }

	override public function destroy():Void {
		super.destroy();
	}
    
}
