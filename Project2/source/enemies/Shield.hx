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
class Shield extends FlxSprite
{

    var parent:ShieldGuy;    
	public var startX:Float;
	public var startY:Float;
	
    public function new(X:Float = 0, Y:Float = 0, Parent:ShieldGuy) 
    {
		super(X, Y);
		startX = X;
		startY = Y;
		//makeGraphic(40, 40, FlxColor.LIME);
		//velocity.x = dx * VELOCTIY;
		parent = Parent;
        
		loadGraphic("assets/images/enemies/skellyshield_WALK_378x343_12fps_strip7.png", true, 34, 34);
		animation.add("stay", [0], 2, true);
		//animation.play("fly", false);
		
		scale.set(.75, .75);
        setSize(width / 2.5, height / 1.75);
		offset.set(width/1.9, height/3);

    }
    
    public override function update():Void {
		
        super.update();
    }
	override public function destroy():Void
	{
		super.destroy();
	}
	
}