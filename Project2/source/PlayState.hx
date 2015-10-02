package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;
import flixel.FlxCamera;
import flixel.util.FlxRect;
import openfl.Assets;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var player:Player;
	var tileMap:FlxTilemap;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.state.bgColor = FlxColor.AZURE;
		FlxG.worldBounds.set(0, 0, 50 * 64, 50 * 64);
		tileMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/testMap.csv");
        var mapTilePath:String = "assets/images/map/tiles2.png";
        tileMap.loadMap(mapData, mapTilePath);
		tileMap.setTileProperties(0, FlxObject.NONE);
		tileMap.setTileProperties(1, FlxObject.ANY);
		tileMap.immovable = true;
        add(tileMap);
		
		
		
		
		add(player = new Player(400, 100, this));
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN, 1);
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		
		if(FlxG.collide(tileMap, player)){
			player.jumpReset();
		}
		super.update();
	}
	
}