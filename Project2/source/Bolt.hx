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
class Bolt extends FlxSprite
{

    var parent:PlayState;
	public static inline var VELOCTIY = 1000;
    
    public function new(X:Float = 0, Y:Float = 0, DX:Float = 0, Parent:PlayState) 
    {
		super(X, Y);
		var dx:Float = DX;
		makeGraphic(40, 10, FlxColor.CORAL);
		velocity.x = dx * VELOCTIY;
		parent = Parent;
        

    }
    
    public override function update():Void {
		
        super.update();
    }
	override public function destroy():Void
	{
		super.destroy();
	}
	
}