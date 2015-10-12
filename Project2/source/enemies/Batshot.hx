package enemies;


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
class Batshot extends FlxSprite
{

    var parent:PlayState;
	public static inline var VELOCTIY = 500;
    
	public var startX:Float;
	public var startY:Float;
	
    public function new(X:Float = 0, Y:Float = 0, DX:Float = 0, Parent:PlayState) 
    {
		super(X, Y);
		startX = X;
		startY = Y;
		var dx:Float = DX;
		//makeGraphic(40, 40, FlxColor.LIME);
		velocity.x = dx * VELOCTIY;
		parent = Parent;
        
		loadGraphic("assets/images/enemies/batBULLET.png", false, 34, 34);
		//animation.add("fly", [0, 1, 2, 3], 18, true);
		//animation.play("fly", false);

    }
    
    public override function update():Void {
		
        super.update();
    }
	override public function destroy():Void
	{
		super.destroy();
	}
	
}