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
		//makeGraphic(40, 10, FlxColor.CORAL);
		velocity.x = dx * VELOCTIY;
		parent = Parent;
        
		loadGraphic("assets/images/damsel/bowbolt_117x59_18fps_strip4.png", true, 117, 59);
		animation.add("fly", [0, 1, 2, 3], 18, true);
		animation.play("fly", false);
		
		scale.set(.75, .75);
		updateHitbox();
		
		if(velocity.x > 0){
			flipX = true;
		} else {
			flipX = false; 
		}
    }
    
    public override function update():Void {
		
        super.update();
    }
	override public function destroy():Void
	{
		super.destroy();
	}
	
}