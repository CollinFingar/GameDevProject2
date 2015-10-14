package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import source.ui.CutScene;

import flash.system.System;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	public static inline var OPTIONS:Int = 3;
	
	var title:FlxText;
	var subtitle:FlxText;
	var opt0txt:FlxText;
	var opt1txt:FlxText;
	var opt2txt:FlxText;
	var loading:FlxText;
	
	var pointer1:FlxSprite;
	var pointer2:FlxSprite;
	var option:Int = 0;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		WillG.skipCutScene = false;
		//WillG.skipCutScene = true;
		
		
		FlxG.state.bgColor = 0xFFF0F0F0;
		
		title = new FlxText(0, FlxG.height / 3-128, FlxG.width, "Damsel" );
		subtitle = new FlxText(0, FlxG.height / 3, FlxG.width, "-- Not So Distressed --" );
		loading = new FlxText( 0, FlxG.height / 2, FlxG.width, "Loading..." );
		
		opt0txt = new FlxText(FlxG.width / 2 - 130, FlxG.height / 2 + 0, 260, "Play");
		opt1txt = new FlxText(FlxG.width / 2 - 130, FlxG.height / 2 + 96, 260, "Learn");
		opt2txt = new FlxText(FlxG.width / 2 - 130, FlxG.height / 2 + 192, 260, "Quit");
		
		title.size = 128;
		title.alignment = "center";
		title.color = FlxColor.BLACK;
		
		subtitle.size = 48;
		subtitle.alignment = "center";
		subtitle.color = FlxColor.BLACK;
		
		opt0txt.size = 48;
		opt0txt.alignment = "center";
		opt1txt.size = 48;
		opt1txt.alignment = "center";
		opt2txt.size = 48;
		opt2txt.alignment = "center";
		
		loading.size = 72;
		loading.alignment = "center";
		loading.color = FlxColor.WHITE;
		loading.visible = false;
		
		add( title );
		add( subtitle );
		add(opt0txt);
		add(opt1txt);
		add(opt2txt);
		add( loading );
		
		super.create();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
				//set y position of cursor based on option choice
		switch(option) {
		case 0:
			opt0txt.color = FlxColor.BLACK;
			opt1txt.color = FlxColor.GRAY;
			opt2txt.color = FlxColor.GRAY;
		case 1:
			opt0txt.color = FlxColor.GRAY;
			opt1txt.color = FlxColor.BLACK;
			opt2txt.color = FlxColor.GRAY;
		case 2:
			opt0txt.color = FlxColor.GRAY;
			opt1txt.color = FlxColor.GRAY;
			opt2txt.color = FlxColor.BLACK;
		}
		
		//listen for keys
		
		if (FlxG.keys.justPressed.UP) {
			option = (option - 1 + OPTIONS) % OPTIONS;
		}
		if (FlxG.keys.justPressed.DOWN) {
			option = (option + 1 + OPTIONS) % OPTIONS;
		}
		if (FlxG.keys.anyJustPressed(["ENTER"])) {
			switch(option) {
			case 0:
				FlxG.state.bgColor = FlxColor.BLACK;
				title.visible = false;
				opt0txt.visible = false;
				opt1txt.visible = false;
				opt2txt.visible = false;
				loading.visible = true;
				FlxG.switchState(new PlayState());
			case 1:
				FlxG.openURL("http://haxeflixel.com/documentation/cheat-sheet/");
			case 2:
				System.exit(0);
			}
		}
		
		super.update();
	}	
}