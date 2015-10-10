package;

import enemies.Batneye;
import enemies.ShieldGuy;
import enemies.Walker;
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

import source.ui.CutScene;
import source.ui.HUD;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var player:Player;
	var tileMap:FlxTilemap;
	var cs:CutScene;
	public var hud:HUD;
	public var coinMap:FlxTilemap;
	public var enemyMap:FlxTilemap;
	public var bolts:Array<Bolt> = [];
	public var coins:Array<Collectible> = [];
	public var walkers:Array<enemies.Walker> = [];
	public var batShots:Array<enemies.Batshot> = [];
	public var batneyes:Array<enemies.Batneye> = [];
	public var shieldGuys:Array<ShieldGuy> = [];
	
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.state.bgColor = FlxColor.CYAN;
		FlxG.worldBounds.set(0, 0, 200 * 64, 150 * 64);
		tileMap = new FlxTilemap();
        var mapData:String = Assets.getText("assets/data/Level1/Level1_Walls.csv");
        var mapTilePath:String = "assets/images/tiles1.png";
		
		var background = new FlxTilemap();
		var backgroundData:String = Assets.getText("assets/data/Level1/Level1_Background.csv");
		background.loadMap(backgroundData, mapTilePath, 64, 64);
		background.setTileProperties(20, FlxObject.NONE);
		background.setTileProperties(4, FlxObject.NONE);
		add(background);
		
        tileMap.loadMap(mapData, mapTilePath, 64, 64);
		tileMap.setTileProperties(19, FlxObject.NONE);
		tileMap.setTileProperties(4, FlxObject.NONE);
		tileMap.setTileProperties(18, FlxObject.ANY);
		tileMap.immovable = true;
        add(tileMap);
		

		//coinMap = new FlxTilemap();
		//var coinData:String = Assets.getText("assets/data/Level1/Level1_Coins.csv");
		//coinMap.loadMap(coinData, mapTilePath, 64, 64);
		//placeCoins();
		
		enemyMap = new FlxTilemap();
		var enemyData:String = Assets.getText("assets/data/Level1/Level1_Enemies.csv");
		enemyMap.loadMap(enemyData, mapTilePath, 64, 64);
		placeEnemies();
		
		//var walker:enemies.Walker;
		//add(walker = new enemies.Walker(2500, 2500, this));
		//walkers.push(walker);
		
		//var bat:Batneye;
		//add(bat = new Batneye(1200, 2750, this));
		//batneyes.push(bat);
		
		add(player = new Player(7000, 300, this));
		//var pnt:FlxPoint = new FlxPoint(-1000, 1000);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
		FlxG.camera.zoom = 1;
		
		/* WILL'S CODE 
		
		var Heart = new FlxSprite();
		Heart.makeGraphic( 32, 32, FlxColor.RED );
		hud = new HUD( this, 3, Heart, 9999 );
		
		var Joe = new FlxSprite( 0, 0 );
		var Mike = new FlxSprite( 0, 0 );
		
		Joe.makeGraphic( 120, 80, FlxColor.GREEN );
		Mike.makeGraphic( 70, 130, FlxColor.RED );
		
		cs = new CutScene( this );
		
		cs.add_character( "Joe", Joe );
		cs.add_character( "Mike", Mike );
		
		cs.add_dialogue( "Joe",  "So what are we doing" );
		cs.add_dialogue( "Mike", "I don't know" );
		cs.add_dialogue( "Mike", "Ask me about it later" );
		cs.add_dialogue( "Joe",  "Yeah okay sure whatever" );
		
		add( Joe );
		add( Mike );
		
		/* WILL'S CODE */
		
		add( new FlxText( 32, 32, 1000, "What the heck is going on" ) );
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
		if ( FlxG.keys.justPressed.ESCAPE ) {
			FlxG.switchState(new MenuState());
		}
		if ( FlxG.collide(tileMap, player) ) {
			player.jumpReset();
		}
		
		//check if bolts need to reset
		checkBolts();
		//check if coins are collected
		checkCoins();
		//check if walkers are colliding with ground
		checkWalkers();
		//check batneyes for colliding with walls, bolts, and players
		checkBats();
		//check batShots for colliding with walls, players, and lifespan
		checkBatShots();
		//check shield guys for colliding with walls, etc..
		checkShieldGuys();
		
		if ( FlxG.keys.justPressed.Q ) {
			cs.change();
		}
		
		super.update();
	}
	
	
	public function addBolt(B:Bolt):Void{
		bolts.push(B);
		add(B);
	}
	
	
	public function checkBolts():Void{
		var d:Array<Bool> = [false, false];
		for (i in 0...bolts.length) {
			var b:Float = bolts[i].x;
			if(FlxG.collide(tileMap, bolts[i])){
				d[i] = true;
			}
			
			else if (b < (player.x - FlxG.camera.width/2) || b > (player.x + FlxG.camera.width/2)){
				d[i] = true;
			} 
			for(j in 0...walkers.length){
				if(FlxG.overlap(bolts[i], walkers[j])){
					d[i] = true;
					walkers[j].healthRemaining -= 1;
					if(walkers[j].healthRemaining < 1){
						remove(walkers[j]);
						walkers.splice(j, 1);
					}
				}
			}
			for(j in 0...batneyes.length){
				if(FlxG.overlap(bolts[i], batneyes[j])){
					d[i] = true;
					batneyes[j].healthRemaining -= 1;
					if(batneyes[j].healthRemaining < 1){
						remove(batneyes[j]);
						batneyes.splice(j, 1);
					}
				}
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
			if (FlxG.overlap(player, coins[i])) {
				hud.AddScore( coins[i].score );
				d.push(i);
			}
		}
		for(i in 0...d.length){
			remove(coins[d[i]]);
			coins.splice(d[i], 1);
		}
	}

	
	public function checkWalkers():Void {
		for(i in 0...walkers.length){
			FlxG.collide(walkers[i], tileMap);
			if(FlxG.overlap(player, walkers[i])){
				hud.damage(1);
				if(walkers[i].x > player.x){
					player.velocity.x = -2500; walkers[i].velocity.x = 1500;
				} else {
					player.velocity.x = 2500; walkers[i].velocity.x = -1500;
				}
			}
			
		}
	}
	
	public function checkShieldGuys():Void {
		for(i in 0...shieldGuys.length){
			FlxG.collide(shieldGuys[i], tileMap);
			if(FlxG.overlap(player, shieldGuys[i])){
				hud.damage(1);
				if(shieldGuys[i].x > player.x){
					player.velocity.x = -5500; //shieldGuys[i].velocity.x = 1500;
				} else {
					player.velocity.x = 5500; //shieldGuys[i].velocity.x = -1500;
				}
			}
			
		}
	}
	
	public function checkBats():Void {
		for(i in 0...batneyes.length){
			if(FlxG.collide(batneyes[i], tileMap)){
				batneyes[i].goingUp = !batneyes[i].goingUp;
			}
			if(FlxG.overlap(player, batneyes[i])){
				hud.damage(1);
				if(batneyes[i].x > player.x){
					player.velocity.x = -4500;
				} else {
					player.velocity.x = 4500;
				}
			}
		}
	}
	
	public function checkBatShots():Void {
		var d:Array<Bool> = [];
		for (i in 0...batShots.length) {
			var b:Float = batShots[i].x;
			if(FlxG.collide(tileMap, batShots[i])){
				d.push(true);
			}
			
			else if (b > batShots[i].startX + FlxG.camera.width  || b < batShots[i].startX - FlxG.camera.width){
				d.push(true);
			} else if (FlxG.collide(player, batShots[i])) {
				hud.damage(1);
				if(batShots[i].x > player.x){
					player.velocity.x = -3000;
				} else {
					player.velocity.x = 3000;
				}
				d.push(true);
			}
			else {
				d.push(false);

			}
			
		}
		for(i in 0...d.length){
			if(d[i]){
				remove(batShots[i]);
				batShots.splice(i, 1);
			}
		}
	}
	
	
		
	public function placeCoins():Void{
		var coinCoords:Array<FlxPoint> = coinMap.getTileCoords(1, true);
		for(i in 0...coinCoords.length){
			var c:Collectible = new Collectible(coinCoords[i].x, coinCoords[i].y, this);
			
			coins.push(c);
			add(c);
		}
	}
	
	public function placeEnemies():Void{
		var walkerCoords:Array<FlxPoint> = enemyMap.getTileCoords(32, true);
		for(i in 0...walkerCoords.length){
			var w:Walker = new Walker(walkerCoords[i].x, walkerCoords[i].y-50, this);
			walkers.push(w);
			add(w);
		}
		var batCoords:Array<FlxPoint> = enemyMap.getTileCoords(34, true);
		for(i in 0...batCoords.length){
			var b:Batneye = new Batneye(batCoords[i].x, batCoords[i].y, 70, this);
			batneyes.push(b);
			add(b);
		}
		var shieldCoords:Array<FlxPoint> = enemyMap.getTileCoords(33, true);
		for(i in 0...shieldCoords.length){
			var s:ShieldGuy = new ShieldGuy(shieldCoords[i].x, shieldCoords[i].y, this);
			shieldGuys.push(s);
			add(s);
		}
	}
	
}