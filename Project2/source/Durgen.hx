package;


import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import haxe.Constraints.FlatEnum;
/**
 * ...
 * @author Team 8
 */
class Durgen extends FlxSprite
{

    var parent:PlayState;
    
	
	
    public function new(X:Float = 0, Y:Float = 0,  Parent:PlayState) 
    {
		super(X, Y);
		parent = Parent;
        
		loadGraphic("assets/images/durgen.png", true, 501, 383);
		
		//scale.set(.75, .75);
        setSize(width / 1.4, height / 1.2);
		offset.set(width / 6, height / 4);
		
	
    }
    
    public override function update():Void {
		
        super.update();
    }
	override public function destroy():Void
	{
		super.destroy();
	}
	
}