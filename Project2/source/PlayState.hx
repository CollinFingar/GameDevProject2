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
import platforms.PlatformGroup;
import platforms.PlatformMoveBasic;
import platforms.PlatformTiles;
import platforms.PlatformUpDown;
import platforms.PlatformLeftRight;
import platforms.PlatformCircle;
import source.ui.SpeechBubble;

import source.ui.CutScene;
import source.ui.HUD;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var player:Player;
	var tileMap:PlatformGroup;
	public var lavaMap:FlxTilemap;
	var cs:CutScene;
	public var hud:HUD;
	public var coinMap:FlxTilemap;
	public var heartMap:FlxTilemap;
	public var enemyMap:FlxTilemap;
	public var bolts:Array<Bolt> = [];
	public var coins:Array<Collectible> = [];
	public var heartPickups:Array<Heart> = [];
	public var walkers:Array<enemies.Walker> = [];
	public var batShots:Array<enemies.Batshot> = [];
	public var batneyes:Array<enemies.Batneye> = [];
	public var shieldGuys:Array<ShieldGuy> = [];
	public var NPCs:Array<NPC> = [];
	
	var dead_and_dying:Int = 0;
	var tmpspd:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.state.bgColor = FlxColor.AZURE;
		FlxG.worldBounds.set(0, 0, 200 * 64, 150 * 64);
		
		tileMap = new PlatformGroup( this, "assets/images/tiles1.png" );
		var backMap = new PlatformTiles( tileMap, "Back Map", "assets/data/Level1/Level1_Background.csv", [5, 20], false );
		var mainMap = new PlatformTiles( tileMap, "Main Map", "assets/data/Level1/Level1_Walls.csv", [18] );
		
		var gah = PlatformMoveBasic.makeController;
		
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement1", "assets/data/Level1/Level1_Platform1.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement2", "assets/data/Level1/Level1_Platform2.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement3", "assets/data/Level1/Level1_Platform3.csv", [64] ), 8 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement4", "assets/data/Level1/Level1_Platform4.csv", [64] ), 8 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement5", "assets/data/Level1/Level1_Platform5.csv", [64] ), 8 );
		
		lavaMap = new FlxTilemap();
		var lavaData:String = Assets.getText("assets/data/Level1/Level1_Lava.csv");
		lavaMap.loadMap(lavaData, "assets/images/tiles1.png", 64, 64);
		add(lavaMap);
		
		coinMap = new FlxTilemap();
		var coinData:String = Assets.getText("assets/data/Level1/Level1_Coins.csv");
		coinMap.loadMap(coinData, "assets/images/tiles1.png", 64, 64);
		placeCoins();
		
		heartMap = new FlxTilemap();
		var heartData:String = Assets.getText("assets/data/Level1/Level1_Health.csv");
		heartMap.loadMap(heartData, "assets/images/tiles1.png", 64, 64);
		placeHearts();
		
		enemyMap = new FlxTilemap();
		var enemyData:String = Assets.getText("assets/data/Level1/Level1_Enemies.csv");
		enemyMap.loadMap(enemyData, "assets/images/tiles1.png", 64, 64);
		placeEnemies();
		
		add(player = new Player(12300, 300, this));	//12300, 300 is start
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
		FlxG.camera.zoom = 1;
		
		/* WILL'S CODE */
		
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
		
		tmpspd = new FlxText( 16, FlxG.height - 48, FlxG.width );
		tmpspd.scrollFactor.set( 0, 0 );
		tmpspd.size = 24;
		add( tmpspd );
		
		placeSpeechBubbles1();
		
		FlxG.sound.playMusic("assets/music/towerbgm.ogg", .2, true);
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
	public function offOfScreen():Bool {
		var xdist = Math.abs( ( FlxG.camera.scroll.x + FlxG.camera.width / 2 ) - player.x );
		var ydist = Math.abs( ( FlxG.camera.scroll.y + FlxG.camera.height / 2 ) - player.y );
		return xdist > FlxG.camera.width / 2 || ydist > FlxG.camera.height / 2;
	}
	override public function update():Void
	{
		if ( FlxG.keys.justPressed.ESCAPE ) {
			FlxG.switchState(new MenuState());
		}
		
		if ( player.isDead() ) {
			if ( dead_and_dying > 0 ) {
				FlxG.camera.color -= 0x00030303;
				dead_and_dying -- ;
				if ( dead_and_dying == 0) {
					FlxG.switchState(new GameOverState());
				}
			} else if ( offOfScreen() ) {
				dead_and_dying = cast(0xFF / 0x03,Int);
			}
		}
		
		tileMap.override_update();
		super.update();
		tileMap.collisionCheck( player );
		player.late_update();
		
		tmpspd.text = Player.ANIMATIONS[player.animctrl.current][Player.ANIMI_NAME];
		
		if(FlxG.collide(lavaMap, player)){
			player.velocity.y = -7000;
			player.velocity.x = -1000;
			hud.damage(3);
			player.setDead();
		}

		checkBolts();
		checkCoins();
		checkHearts();
		checkWalkers();
		checkBats();
		checkBatShots();
		checkShieldGuys();
		checkSpeechBubbles();
		
	}
	
	
	public function addBolt(B:Bolt):Void{
		bolts.push(B);
		add(B);
	}
	
	
	public function checkBolts():Void {
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
			for(j in 0...shieldGuys.length){
				if(FlxG.overlap(bolts[i], shieldGuys[j])){
					d[i] = true;
					if(shieldGuys[j].shieldBroken){
						shieldGuys[j].healthRemaining -= 1;
						if(shieldGuys[j].healthRemaining < 1){
							remove(shieldGuys[j]);
							shieldGuys.splice(j, 1);
						}
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
	
	public function checkCoins():Void {
		var d:Array<Int> = [];
		for (i in 0...coins.length){
			if (FlxG.overlap(player, coins[i])) {
				hud.AddScore( coins[i].score );
				FlxG.sound.play("assets/sounds/coin.wav", 1, false);
				d.push(i);
			}
		}
		for(i in 0...d.length){
			remove(coins[d[i]]);
			coins.splice(d[i], 1);
		}
	}
	
	
	public function checkHearts():Void{
		var d:Array<Int> = [];
		for (i in 0...heartPickups.length){
			if (FlxG.overlap(player, heartPickups[i])) {
				hud.heal(1);
				FlxG.sound.play("assets/sounds/heartget.wav", 1, false);
				d.push(i);
			}
		}
		for(i in 0...d.length){
			remove(heartPickups[d[i]]);
			heartPickups.splice(d[i], 1);
		}
	}
	
	
	public function placeHearts():Void {
		var heartCoords:Array<FlxPoint> = heartMap.getTileCoords(79, true);
		for(i in 0...heartCoords.length) {
			var h:Heart = new Heart(heartCoords[i].x, heartCoords[i].y, this);
			
			heartPickups.push(h);
			add(h);
		}
	}
	
	public function placeCoins():Void {
		var coinCoords:Array<FlxPoint> = coinMap.getTileCoords(65, true);
		for(i in 0...coinCoords.length) {
			var c:Collectible = new Collectible(coinCoords[i].x, coinCoords[i].y, this);
			
			coins.push(c);
			add(c);
		}
	}
	
	public static inline var ENEMY_WALKER:Int 	= 0;
	public static inline var ENEMY_SHIELDGUY:Int= 1;
	public static inline var ENEMY_BAT:Int	 	= 2;
	public static inline var ENEMY_BULLET:Int 	= 3;
	
	public static inline var PLAYER_HEALTH:Int 	= 0;
	public static inline var PLAYER_RECOIL:Int 	= 1;
	public static inline var ENEMY_RECOIL:Int 	= 2;
	
	public static var ENEMY_BOUNCE:Array<Array<Int>> =
	[
	[ 1, 2500, 1500 ],
	[ 1, 5500, 0 ],
	[ 1, 4500, 0 ],
	[ 1, 3000, 0 ]
	];
	
	public function checkHit( obj:FlxSprite, id:Int ):Bool {
		if ( FlxG.overlap( player, obj ) ) {
			if ( !player.isDeadOrHurt() ) {
				hud.damage( ENEMY_BOUNCE[id][PLAYER_HEALTH] );
				
				if ( hud.getHealth() == 0 ) {
					player.setDead();
					player.velocity.y = -2000;
					if ( obj.x < player.x ) {
						player.velocity.x = 6000;
					} else {
						player.velocity.x = -6000;
					}
				} else {
					player.setHurt();
					if ( obj.x < player.x ) {
						player.velocity.x = ENEMY_BOUNCE[id][PLAYER_RECOIL];
						obj.velocity.x = -ENEMY_BOUNCE[id][ENEMY_RECOIL];
					} else {
						player.velocity.x = -ENEMY_BOUNCE[id][PLAYER_RECOIL];
						obj.velocity.x = ENEMY_BOUNCE[id][ENEMY_RECOIL];
					}
					player.velocity.y *= .25;
				}
			}
			return true;
		} return false;
	}
	
	public function checkWalkers():Void {
		for(i in 0...walkers.length){
			FlxG.collide(walkers[i], tileMap);
			checkHit( walkers[i], ENEMY_WALKER );
		}
	}
	
	public function checkShieldGuys():Void {
		for(i in 0...shieldGuys.length){
			FlxG.collide(shieldGuys[i], tileMap);
			checkHit( shieldGuys[i], ENEMY_SHIELDGUY);
		}
	}
	
	public function checkBats():Void {
		for(i in 0...batneyes.length){
			if(FlxG.collide(batneyes[i], tileMap)){
				batneyes[i].goingUp = !batneyes[i].goingUp;
			}
			checkHit( batneyes[i], ENEMY_BAT );
		}
	}
	
	public function checkBatShots():Void {
		var d:Array<Bool> = [];
		for (i in 0...batShots.length) {
			var b:Float = batShots[i].x;
			if ( FlxG.collide(tileMap, batShots[i]) ) {
				d.push(true);
			} else if (b > batShots[i].startX + FlxG.camera.width  || b < batShots[i].startX - FlxG.camera.width){
				d.push(true);
			} else if ( checkHit( batShots[i], ENEMY_BULLET ) ) {
				d.push(true);
			} else {
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
	
	public function placeEnemies():Void {	
		var walkerCoords:Array<FlxPoint> = enemyMap.getTileCoords(32, true);
		//if(walkerCoords.length > 0){
			for(i in 0...walkerCoords.length){
				var w:Walker = new Walker(walkerCoords[i].x, walkerCoords[i].y-50, this);
				walkers.push(w);
				add(w);
			}
		//}
		
		var batCoords:Array<FlxPoint> = enemyMap.getTileCoords(34, true);
		//if(batCoords.length > 0){
			for(i in 0...batCoords.length){
				var b:Batneye = new Batneye(batCoords[i].x, batCoords[i].y, 70, this);
				batneyes.push(b);
				add(b);
			}
		//}
		
		var shieldCoords:Array<FlxPoint> = enemyMap.getTileCoords(33, true);
		//if(shieldCoords.length > 0){
			for(i in 0...shieldCoords.length){
				var s:ShieldGuy = new ShieldGuy(shieldCoords[i].x, shieldCoords[i].y, this);
				shieldGuys.push(s);
				add(s);
			}
		//}
		
	}
	
	
	public function placeSpeechBubbles1():Void{
		var pnt:FlxPoint = new FlxPoint(11500, 600);
		var spch:SpeechBubble = new SpeechBubble(this, pnt, 180, 50, "What a jerk..", .1, 1.2);
		var npc:NPC = new NPC(pnt, spch, true, 300, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(12300, 600);
		spch = new SpeechBubble(this, pnt, 200, 100, "I should probably get out of here.", .1, 1.2);
		npc = new NPC(pnt, spch, true, 300, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(10500, 600);
		spch = new SpeechBubble(this, pnt, 200, 100, "Was that knight actually powerful?", .1, 1.2);
		npc = new NPC(pnt, spch, true, 300, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(9600, 600);
		spch = new SpeechBubble(this, pnt, 200, 100, "I could have taken this guy out.", .1, 1.2);
		npc = new NPC(pnt, spch, true, 300, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(6000, 1000);
		spch = new SpeechBubble(this, pnt, 200, 120, "My legs are going to be great when I'm out of here.", .1, 1.2);
		npc = new NPC(pnt, spch, true, 500, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(8500, 2800);
		spch = new SpeechBubble(this, pnt, 200, 120, "I'm going to miss my bed. It was a nice bed.", .1, 1.2);
		npc = new NPC(pnt, spch, true, 500, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(9800, 4800);
		spch = new SpeechBubble(this, pnt, 180, 50, "Am I out yet?", .1, 1.2);
		npc = new NPC(pnt, spch, true, 500, this);
		NPCs.push(npc);
		add(npc);
		
		pnt = new FlxPoint(5000, 7000);
		spch = new SpeechBubble(this, pnt, 200, 120, "Maybe the occasional tour of this Castle would help out.", .1, 1.2);
		npc = new NPC(pnt, spch, true, 500, this);
		NPCs.push(npc);
		add(npc);
		
	}
	
	public function checkSpeechBubbles():Void{
		for(i in 0...NPCs.length){
			NPCs[i].checkIfPlayerNear();
		}
	}
	
	
	
}