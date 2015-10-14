package;


import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import haxe.Constraints.FlatEnum;
import source.ui.SpeechBubble;
/**
 * ...
 * @author Team 8
 */
class Noob extends FlxSprite
{

    var parent:PlayState;
    
	var speechBubble:SpeechBubble;
	var dist:Float;
	
	
    public function new(start:FlxPoint, SpBu:SpeechBubble, DIST:Float, AssetPath:String, Parent:PlayState) 
    {
		super(start.x, start.y);
		parent = Parent;
        speechBubble = SpBu;
		dist = DIST;
		
		if(AssetPath == "assets/images/outcoldknight_370x305_12fps_strip4.png"){
			loadGraphic(AssetPath, true, 370, 305);
			animation.add("idle", [0, 1, 2, 3], 12, true);
			animation.play("idle", false);
		} else if (AssetPath == "assets/images/trappedguy1_idle_307x343_1fps_strip2.png") {
			loadGraphic(AssetPath, true, 307, 343);
			animation.add("idle", [0, 1], 1, true);
			animation.play("idle", false);
		}
		else {
			loadGraphic(AssetPath, true, 307, 343);
		}
    }
    
    public override function update():Void {
		
        super.update();
    }
	
	override public function destroy():Void
	{
		super.destroy();
	}
	
	public function checkIfPlayerNear():Void{
		var distance:Float = getDistance(this.parent.player.x, this.parent.player.y, this.x, this.y);
		if(distance < dist){
			speechBubble.open();
			
		} else { 
			speechBubble.close();
		}

	}
	
	public function getDistance(x1:Float, y1:Float, x2:Float, y2:Float):Float{
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	}
	
}