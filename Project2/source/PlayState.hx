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
import platforms.PlatformControlSignaller;
import platforms.PlatformTiles;
import platforms.PlatformUpDown;
import platforms.PlatformLeftRight;
import platforms.PlatformCircle;
import platforms.PlatformFalling;

import Level1_Script;
import MiscCage;
import source.ui.SpeechBubble;
import source.ui.CutScene;
import source.ui.HUD;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public var currentLevel:Int;
	
	
	public var player:Player;
	public var prince:Prince;
	public var tileMap:PlatformGroup;
	public var lavaMap:FlxTilemap;
	public var cs:CutScene;
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
	public var switches:Array<PlatformControlSignaller> = [];
	public var showplats:Array<PlatformTiles> = [];
	public var NPCs:Array<NPC> = [];
	public var scr:Script;
	public var durgen:Durgen;
	
	public var noob1:Noob;
	public var noob2:Noob;
	public var noob3:Noob;
	public var noob1InPlay:Bool = false;
	public var noob2InPlay:Bool = false;
	public var noob3InPlay:Bool = false;
	
	public var endLocation:FlxPoint;
	
	// she is dead
	var dead_and_dying:Int = 0;
	var tmpspd:FlxText;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		if(Reg.level == 1){
			buildLevel1();
		} else if(Reg.level == 2){
			buildLevel2();
		} else if(Reg.level == 3){
			buildLevel3();
		}
	}
	
	
	public function buildLevel1():Void{
			
		
		super.create();
		
		endLocation = new FlxPoint(1500, 9000);
		
		FlxG.state.bgColor = FlxColor.AZURE;
		FlxG.worldBounds.set(0, 0, 200 * 64, 150 * 64);
		
		tileMap = new PlatformGroup( this, "assets/images/tiles1.png" );
		var backMap = new PlatformTiles( tileMap, "Back Map", "assets/data/Level1/Level1_Background.csv", [5, 20], false );
		
		lavaMap = new FlxTilemap();
		var lavaData:String = Assets.getText("assets/data/Level1/Level1_Lava.csv");
		lavaMap.loadMap(lavaData, "assets/images/tiles1.png", 64, 64);
		add(lavaMap);
		
		var mainMap = new PlatformTiles( tileMap, "Main Map", "assets/data/Level1/Level1_Walls.csv", [18] );
		
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement1", "assets/data/Level1/Level1_Platform1.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement2", "assets/data/Level1/Level1_Platform2.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement3", "assets/data/Level1/Level1_Platform3.csv", [64] ), 8 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement4", "assets/data/Level1/Level1_Platform4.csv", [64] ), 8 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement5", "assets/data/Level1/Level1_Platform5.csv", [64] ), 8 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement6", "assets/data/Level1/Level1_Platform6.csv", [64] ), 2 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement7", "assets/data/Level1/Level1_Platform7.csv", [64] ), 2 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement8", "assets/data/Level1/Level1_Platform8.csv", [64] ), 2 );
		
		PlatformControlSignaller.makeController( this, tileMap, "assets/data/Level1/Level1_Switch1.csv", "assets/data/Level1/Level1_SwitchPlatform1.csv" );
		PlatformControlSignaller.makeController( this, tileMap, "assets/data/Level1/Level1_Switch2.csv", "assets/data/Level1/Level1_SwitchPlatform2.csv" );
		
		var cageBack = new FlxSprite( 0, 0, "assets/images/enemies/cageBACK.png" );
		add( cageBack );
		
		var fallMap = new FlxTilemap();
		var fallData:String = Assets.getText("assets/data/Level1/Level1_Falling.csv");
		fallMap.loadMap( fallData, "assets/images/tiles1.png", 64, 64 );
		placePlatforms( fallMap );
		
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
		
		add(player = new Player(12300, 300, this));	//12300, 300 is start of 1. 2000, 9000 by end.
		
		var pnt:FlxPoint = new FlxPoint(8800, 4705);
		var speechpnt:FlxPoint = new FlxPoint(8680, 4650);
		var spch:SpeechBubble = new SpeechBubble(this, speechpnt, 200, 270, "First day on the job! They said the new guards should be towards the top of the tower today, because they're trying something new. \n\n Who are you, the captain?", .1, 1.2);
		noob1 = new Noob(pnt, spch, 800, "assets/images/noobknight.png", this);
		add(noob1);
		noob1InPlay = true;
		
		
		var pnt:FlxPoint = new FlxPoint(7500, 2850);
		var speechpnt:FlxPoint = new FlxPoint(7700, 2750);
		var spch:SpeechBubble = new SpeechBubble(this, speechpnt, 200, 210, "He was... too powerful... \n\nand brave... \n\n\nand handsome....", .1, 1.2);
		noob2 = new Noob(pnt, spch, 600, "assets/images/outcoldknight_370x305_12fps_strip4.png", this);
		add(noob2);
		noob2InPlay = true;
		
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
		FlxG.camera.zoom = 1;
		
		prince = new Prince(11000, 600, this );
		add( prince );
		
		//pnt = new FlxPoint(10500, 600);
		durgen = new Durgen(10000, 730, this);
		durgen.immovable = true;
		add(durgen);
		
		var cage = new MiscCageFront( 12180, 330, this, cageBack );
		var cloud = new DustCloud( 11800, 530, this );
		
		/* WILL'S CODE */
		
		var Heart = new FlxSprite();
		Heart.makeGraphic( 32, 32, FlxColor.RED );
		hud = new HUD( this, 5, Heart, 10000, Reg.score );
		
		cs = new CutScene( this );
		
		var prinGrr = new FlxSprite(0, 0, "assets/images/talking/princess_grr.png");
		var prinHmm = new FlxSprite(0, 0, "assets/images/talking/princess_hmm.png");
		var prinNeutral = new FlxSprite(0, 0, "assets/images/talking/princess_neutral.png");
		var prinSmile = new FlxSprite(0, 0, "assets/images/talking/princess_smile.png");
		var prinUhh = new FlxSprite(0, 0, "assets/images/talking/princess_uhh.png");
		
		var prinNorm = new FlxSprite(0, 0, "assets/images/talking/prince_talk.png");
		var prinDead = new FlxSprite(0, 0, "assets/images/talking/prince_outcold.png");
		
		cs.add_character( "Princess", "grr", prinGrr );
		cs.add_character( "Princess", "hmm", prinHmm );
		cs.add_character( "Princess", "neutral", prinNeutral );
		cs.add_character( "Princess", "smile", prinSmile );
		cs.add_character( "Princess", "uhh", prinUhh );
		
		cs.add_character( "Knight", "normal", prinNorm );
		cs.add_character( "Knight", "dead", prinDead );
		
		trace( cs.portraits["Knight"]["normal"] );
		
		add( prinGrr );
		add( prinHmm );
		add( prinNeutral );
		add( prinSmile );
		add( prinUhh );
		
		add( prinNorm );
		add( prinDead );
		
		scr = new ScriptLvl1( this, cs, [player, prince, cage, cloud] );
		
		/* WILL'S CODE */
		
		tmpspd = new FlxText( 16, FlxG.height - 48, FlxG.width );
		tmpspd.scrollFactor.set( 0, 0 );
		tmpspd.size = 24;
		//add( tmpspd );
		
		if ( WillG.skipCutScene ) {
			player.animctrl.force_state( Player.ANIM_IDLE );
			prince.signal(0);
			prince.x = 11963;
			prince.y = 621.5;
			cage.alpha = 0.0;
		} else {
			scr.start();
		}
		
		
		placeSpeechBubbles1();
		
		if ( WillG.skipCutScene ) {
			FlxG.sound.playMusic("assets/music/towerbgm.ogg", .2, true);
		} else {
			FlxG.sound.playMusic("assets/music/openingscenebgm.ogg", .2, true);
		}
	}
	
	public function buildLevel2():Void{
			
		
		super.create();
		
		endLocation = new FlxPoint(1500, 600);
		
		FlxG.state.bgColor = FlxColor.CHARCOAL;
		FlxG.worldBounds.set(0, 0, 200 * 64, 150 * 64);
		
		tileMap = new PlatformGroup( this, "assets/images/tiles1.png" );
		var backMap = new PlatformTiles( tileMap, "Back Map", "assets/data/Level2/Level2_Background.csv", [5, 8, 20], false );
		
		lavaMap = new FlxTilemap();
		var lavaData:String = Assets.getText("assets/data/Level2/Level2_Lava.csv");
		lavaMap.loadMap(lavaData, "assets/images/tiles1.png", 64, 64);
		add(lavaMap);
		
		var mainMap = new PlatformTiles( tileMap, "Main Map", "assets/data/Level2/Level2_Walls.csv", [18] );
		
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement1", "assets/data/Level2/Level2_Platform1.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement2", "assets/data/Level2/Level2_Platform2.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement3", "assets/data/Level2/Level2_Platform3.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement4", "assets/data/Level2/Level2_Platform4.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement5", "assets/data/Level2/Level2_Platform5.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement6", "assets/data/Level2/Level2_Platform6.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement7", "assets/data/Level2/Level2_Platform7.csv", [64] ), 3 );
		
		//var sw:PlatformControlSignaller = new PlatformControlSignaller( tileMap, 12000, 300, "assets/images/misc/switch_UNPRESSED.png" );
		
		
		
		coinMap = new FlxTilemap();
		var coinData:String = Assets.getText("assets/data/Level2/Level2_Coins.csv");
		coinMap.loadMap(coinData, "assets/images/tiles1.png", 64, 64);
		placeCoins();
		
		heartMap = new FlxTilemap();
		var heartData:String = Assets.getText("assets/data/Level2/Level2_Health.csv");
		heartMap.loadMap(heartData, "assets/images/tiles1.png", 64, 64);
		placeHearts();
		
		enemyMap = new FlxTilemap();
		var enemyData:String = Assets.getText("assets/data/Level2/Level2_Enemy.csv");
		enemyMap.loadMap(enemyData, "assets/images/tiles1.png", 64, 64);
		placeEnemies();
		
		add(player = new Player(9000, 1200, this));	//12300, 300 is start
		player.animctrl.force_state(Player.ANIM_IDLE);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
		FlxG.camera.zoom = 1;
		
		/* WILL'S CODE */
		
		var Heart = new FlxSprite();
		Heart.makeGraphic( 32, 32, FlxColor.RED );
		hud = new HUD( this, 5, Heart, 10000, Reg.score);
		
		tmpspd = new FlxText( 16, FlxG.height - 48, FlxG.width );
		tmpspd.scrollFactor.set( 0, 0 );
		tmpspd.size = 24;
		//add( tmpspd );
		
		//pnt = new FlxPoint(10500, 600);
		
		
		
		//placeSpeechBubbles1();
		
		FlxG.sound.playMusic("assets/music/undergroundbgm.ogg", .2, true);
	}
	
	public function buildLevel3():Void{
		super.create();
		
		endLocation = new FlxPoint(1500, 600);
		
		FlxG.state.bgColor = FlxColor.AZURE;
		FlxG.worldBounds.set(0, 0, 200 * 64, 150 * 64);
		
		tileMap = new PlatformGroup( this, "assets/images/tiles1.png" );
		var backMap = new PlatformTiles( tileMap, "Back Map", "assets/data/Level3/Level3_Background.csv", [5, 8, 20, 39, 40], false );
		
		//lavaMap = new FlxTilemap();
		//var lavaData:String = Assets.getText("assets/data/Level3/Level3_Lava.csv");
		//lavaMap.loadMap(lavaData, "assets/images/tiles1.png", 64, 64);
		//add(lavaMap);
		
		var lavaMap = new PlatformTiles(tileMap, "Lava Map", "assets/data/Level3/Level3_Lava.csv", [-1], true);
		
		var mainMap = new PlatformTiles( tileMap, "Main Map", "assets/data/Level3/Level3_Walls.csv", [18] );
		
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement1", "assets/data/Level3/Level3_Platform1.csv", [64] ), 3 );
		PlatformMoveBasic.makeController( new PlatformMoveBasic( tileMap, "Movement2", "assets/data/Level3/Level3_Platform2.csv", [64] ), 3 );
		
		//var sw:PlatformControlSignaller = new PlatformControlSignaller( tileMap, 12000, 300, "assets/images/misc/switch_UNPRESSED.png" );
		//new PlatformFalling( tileMap, 11500, 400 );
		
		coinMap = new FlxTilemap();
		var coinData:String = Assets.getText("assets/data/Level3/Level3_Coins.csv");
		coinMap.loadMap(coinData, "assets/images/tiles1.png", 64, 64);
		placeCoins();
		
		heartMap = new FlxTilemap();
		var heartData:String = Assets.getText("assets/data/Level3/Level3_Health.csv");
		heartMap.loadMap(heartData, "assets/images/tiles1.png", 64, 64);
		placeHearts();
		
		enemyMap = new FlxTilemap();
		var enemyData:String = Assets.getText("assets/data/Level3/Level3_Enemies.csv");
		enemyMap.loadMap(enemyData, "assets/images/tiles1.png", 64, 64);
		placeEnemies();
		
		add(player = new Player(12000, 2400, this));	//12300, 300 is start
		player.animctrl.force_state(Player.ANIM_IDLE);
		FlxG.camera.follow(player, FlxCamera.STYLE_TOPDOWN);
		FlxG.camera.zoom = 1;
		
		/* WILL'S CODE */
		
		var Heart = new FlxSprite();
		Heart.makeGraphic( 32, 32, FlxColor.RED );
		hud = new HUD( this, 5, Heart, 10000, Reg.score);
		
		tmpspd = new FlxText( 16, FlxG.height - 48, FlxG.width );
		tmpspd.scrollFactor.set( 0, 0 );
		tmpspd.size = 24;
		//add( tmpspd );
		
		//pnt = new FlxPoint(10500, 600);
		
		
		
		//placeSpeechBubbles1();
		
		FlxG.sound.playMusic("assets/music/fieldbgm.ogg", .2, true);
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
		
		if(Math.sqrt((player.x - endLocation.x)*(player.x - endLocation.x) + (player.y - endLocation.y) * (player.y - endLocation.y)) < 200){
			Reg.level += 1;
			Reg.score = hud.score;
			FlxG.switchState(new PlayState());
		}
		
		
		if ( FlxG.keys.justPressed.ESCAPE ) {
			FlxG.switchState(new MenuState());
		}

		
		if(Reg.level==1){
			scr.update();
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
		if(Reg.level==1){
			tileMap.collisionCheck( prince );
		}
		player.late_update();
		
		tmpspd.text = Player.ANIMATIONS[player.animctrl.current][Player.ANIMI_NAME];
		
		if (!player.isDead() && FlxG.collide(lavaMap, player)) {
			trace("meh");
			player.velocity.y = -7000;
			if ( Std.random(2) == 0 )
				player.velocity.x = 1000;
			else
				player.velocity.x = -1000;
			hud.damage(100);
			player.setDead();
		}
		
		FlxG.collide(player, durgen);
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
				FlxG.sound.play("assets/sounds/bolthitwall.wav", .3, false);
			} else if (b < (player.x - FlxG.camera.width/2) || b > (player.x + FlxG.camera.width/2)){
				d[i] = true;
			}
			for(j in 0...switches.length){
				if (FlxG.overlap(bolts[i], switches[j])) {
					trace( "SWITCH " + i );
					d[i] = true;
					switches[i].send_signal( 0 );
				}
			}
			for(j in 0...walkers.length){
				if(FlxG.overlap(bolts[i], walkers[j])){
					d[i] = true;
					walkers[i].damage( 1 );
					walkers[i].velocity.x = bolts[i].velocity.x;
				}
			}
			for(j in 0...batneyes.length){
				if (FlxG.overlap(bolts[i], batneyes[j])) {
					d[i] = true;
					batneyes[j].killByWeapon();
				}
			}
			for(j in 0...shieldGuys.length){
				if(FlxG.overlap(bolts[i], shieldGuys[j])){
					d[i] = true;
					if(shieldGuys[j].shield.isDestroyed){
						shieldGuys[j].damage( 1 );
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
		if ( player.isDead() )
			return;
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
	
	
	public function checkHearts():Void {
		if ( player.isDead() )
			return;
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
	
	public function placePlatforms( tmap:FlxTilemap ) {
		var coords:Array<FlxPoint> = tmap.getTileCoords(78, false);
		for(i in 0...coords.length)
			new PlatformFalling( tileMap, coords[i].x, coords[i].y );
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
		if ( !player.isDeadOrHurt() && FlxG.overlap( player, obj ) ) {
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
			return true;
		} return false;
	}
	
	public function checkWalkers():Void {
		for(i in 0...walkers.length){
			FlxG.collide(walkers[i], tileMap);
			if ( !walkers[i].isDead() )
				checkHit( walkers[i], ENEMY_WALKER );
		}
	}
	
	public function checkShieldGuys():Void {
		for(i in 0...shieldGuys.length) {
			FlxG.collide(shieldGuys[i], tileMap);
			if ( !player.isDeadOrHurt() && !shieldGuys[i].isDead() && FlxG.overlap( player, shieldGuys[i] ) ) {
				if ( shieldGuys[i].isAttacking ) {
					hud.damage( ENEMY_BOUNCE[ENEMY_SHIELDGUY][PLAYER_HEALTH] );
					if ( hud.getHealth() == 0 ) {
						player.setDead();
						player.velocity.y = -2000;
						if ( shieldGuys[i].x < player.x ) {
							player.velocity.x = 6000;
						} else {
							player.velocity.x = -6000;
						}
					} else {
						player.setHurt();
						if ( shieldGuys[i].x < player.x ) {
							player.velocity.x = ENEMY_BOUNCE[ENEMY_SHIELDGUY][PLAYER_RECOIL];
							shieldGuys[i].velocity.x = -ENEMY_BOUNCE[ENEMY_SHIELDGUY][ENEMY_RECOIL];
						} else {
							player.velocity.x = -ENEMY_BOUNCE[ENEMY_SHIELDGUY][PLAYER_RECOIL];
							shieldGuys[i].velocity.x = ENEMY_BOUNCE[ENEMY_SHIELDGUY][ENEMY_RECOIL];
						}
						player.velocity.y *= .25;
					}
				} else {
					FlxObject.separateX( player, shieldGuys[i] );
				}
			}
		}
	}
	
	public function checkBats():Void {
		for (i in 0...batneyes.length) {
			
			var col:Bool = FlxG.collide(batneyes[i], tileMap);
			if ( !batneyes[i].isDead() ) {
				if( col ){
					batneyes[i].goingUp = !batneyes[i].goingUp;
				}
				if ( FlxG.overlap( player, batneyes[i] ) ) {
					if ( !player.isDeadOrHurt() ) {
						FlxObject.separateX( player, batneyes[i] );
						FlxObject.separateY( player, batneyes[i] );
						
						if ( ( batneyes[i].touching & FlxObject.UP != 0 ) && ( player.touching & FlxObject.DOWN != 0 ) ) {
							
							batneyes[i].killByStomp();
							player.velocity.y = -5000;
							
						} else {
							hud.damage( ENEMY_BOUNCE[ENEMY_BAT][PLAYER_HEALTH] );
							
							if ( hud.getHealth() == 0 ) {
								player.setDead();
								player.velocity.y = -2000;
								if ( batneyes[i].x < player.x ) {
									player.velocity.x = 6000;
								} else {
									player.velocity.x = -6000;
								}
							} else {
								player.setHurt();
								if ( batneyes[i].x < player.x ) {
									player.velocity.x = ENEMY_BOUNCE[ENEMY_BAT][PLAYER_RECOIL];
									batneyes[i].velocity.x = -ENEMY_BOUNCE[ENEMY_BAT][ENEMY_RECOIL];
								} else {
									player.velocity.x = -ENEMY_BOUNCE[ENEMY_BAT][PLAYER_RECOIL];
									batneyes[i].velocity.x = ENEMY_BOUNCE[ENEMY_BAT][ENEMY_RECOIL];
								}
								player.velocity.y *= .25;
							}
						}
					}
				}
			}
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
			}
		//}
		
	}
	
	
	public function placeSpeechBubbles1():Void {
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
	
	public function checkSpeechBubbles():Void {
		if (!WillG.speechBubblesActive)
			return;
		for(i in 0...NPCs.length){
			NPCs[i].checkIfPlayerNear();
		}
		if(noob1InPlay){
			noob1.checkIfPlayerNear();
		}
		if(noob2InPlay){
			noob2.checkIfPlayerNear();
		}
		if(noob3InPlay){
			noob3.checkIfPlayerNear();
		}
	}
	
	
	
}