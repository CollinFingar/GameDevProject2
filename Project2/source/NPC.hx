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
class NPC extends FlxSprite
{

    var parent:PlayState;
    
	var speechBubble:SpeechBubble;
	var followPlayer:Bool;
	var dist:Float;
	
    public function new(X:Float = 0, Y:Float = 0, SpBu:SpeechBubble, FollowPlayer:Bool = false, DIST:Float, Parent:PlayState) 
    {
		super(X, Y);
		parent = Parent;
		followPlayer = FollowPlayer;
        speechBubble = SpBu;
		dist = DIST;
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
		
		if(followPlayer){
			//var pnt:FlxPoint = new FlxPoint(this.parent.player.x, this.parent.player.y);
			this.speechBubble.bubble.x = this.parent.player.x;
			
		}
	}
	
	public function getDistance(x1:Float, y1:Float, x2:Float, y2:Float):Float{
		return Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
	}
	
}