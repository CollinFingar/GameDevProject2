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
class GameOverState extends FlxState
{
	public static inline var OPTIONS:Int = 2;
	
	var title:FlxText;
	var opt0txt:FlxText;
	var opt1txt:FlxText;
	var loading:FlxText;
	var option:Int = 0;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		WillG.skipCutScene = true;
		
		FlxG.state.bgColor = FlxColor.BLACK;
		
		title = new FlxText(0, FlxG.height / 3, FlxG.width, "Game Over!" );
		loading = new FlxText( 0, FlxG.height / 2, FlxG.width, "Loading..." );
		
		opt0txt = new FlxText(FlxG.width / 2 - 130, FlxG.height / 2 + 0, 260, "Retry");
		opt1txt = new FlxText(FlxG.width / 2 - 130, FlxG.height / 2 + 96, 260, "Quit");
		
		title.size = 128;
		title.alignment = "center";
		title.color = FlxColor.WHITE;
		opt0txt.size = 48;
		opt0txt.alignment = "center";
		opt1txt.size = 48;
		opt1txt.alignment = "center";
		loading.size = 72;
		loading.alignment = "center";
		loading.color = FlxColor.WHITE;
		loading.visible = false;
		
		add( title );
		add(opt0txt);
		add(opt1txt);
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
			opt0txt.color = FlxColor.WHITE;
			opt1txt.color = FlxColor.GRAY;
		case 1:
			opt0txt.color = FlxColor.GRAY;
			opt1txt.color = FlxColor.WHITE;
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
				title.visible = false;
				opt0txt.visible = false;
				opt1txt.visible = false;
				loading.visible = true;
				FlxG.switchState(new PlayState());
			case 1:
				FlxG.switchState(new MenuState());
			}
		}
		
		super.update();
	}	
}