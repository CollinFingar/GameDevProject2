package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxPoint;
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
	public var coinMap:FlxTilemap;
	public var bolts:Array<Bolt> = [];
	public var coins:Array<Collectible> = [];
	
	
	var walker:Walker;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		FlxG.state.bgColor = FlxColor.AZURE;
		FlxG.worldBounds.set(0, 0, 50 * 64, 50 * 64);
		tileMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/testWorld.csv");
        var mapTilePath:String = "assets/images/map/tiles2.png";
        tileMap.loadMap(mapData, mapTilePath);
		tileMap.setTileProperties(0, FlxObject.NONE);
		tileMap.setTileProperties(1, FlxObject.ANY);
		tileMap.immovable = true;
        add(tileMap);

		coinMap = new FlxTilemap();
		var coinData:String = Assets.getText("assets/data/collectibleLocations.csv");
		coinMap.loadMap(coinData, mapTilePath);
		placeCoins();
		
		add(walker = new Walker(2500, 2500, this));
		
		add(player = new Player(1700, 1600, this));
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER, 1);
		
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
		checkBolts();
		checkCoins();
		FlxG.collide(walker, tileMap);
		
		super.update();
	}
	
	
	public function addBolt(B:Bolt):Void{
		bolts.push(B);
		add(B);
	}
	
	
	public function checkBolts():Void{
		var d:Array<Bool> = [false, false, false];
		for (i in 0...bolts.length) {
			var b:Float = bolts[i].x;
			if(FlxG.collide(tileMap, bolts[i])){
				d[i] = true;
			}
			
			else if (b < (player.x - FlxG.camera.width/2) || b > (player.x + FlxG.camera.width/2)){
				d[i] = true;
			}
		}
		for(i in 0...d.length){
			if(d[i]){
				remove(bolts[i]);
				bolts.splice(i, 1);
			}
		}
	}
	
	public function checkCoins():Void{
		var d:Array<Int> = [];
		for (i in 0...coins.length){
			if(FlxG.overlap(player, coins[i])){
				player.score += coins[i].score;
				d.push(i);
			}
		}
		for(i in 0...d.length){
			remove(coins[d[i]]);
			coins.splice(d[i], 1);
		}
	}
	
	public function placeCoins():Void{
		var coinCoords:Array<FlxPoint> = coinMap.getTileCoords(2, true);
		for(i in 0...coinCoords.length){
			var c:Collectible = new Collectible(coinCoords[i].x, coinCoords[i].y, this);
			
			coins.push(c);
			add(c);
		}
	}
	
}