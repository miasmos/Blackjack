package com.poole.blackjack {
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import com.poole.blackjack.helper.HandleXML;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import com.poole.blackjack.game.TouchEvents;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	//click the gear in the top right for audio things
	//switches states to settings state
	//HandleXML imports all nodes with the 'embed' tag and stores them in an array in main for reference
	//Audio files are initialized with the AudioControl class. This handles all playing/stopping etc related to audio
	//AudioControl is initialized as an extension of SourceControl. This is a generic class with the functions every source should have
	
	public class Main extends MovieClip {
		private var game:MovieClip;	//pass stage ref
		private var intro:MovieClip;
		private var menu:MovieClip;
		private var settings:MovieClip;
		private var cState;	//state of app
		//private var xmlLoader:HandleXML = new HandleXML(this,'embed/data.void');
		private var xmlLoader:HandleXML = new HandleXML(this,'data',false);
		private var xml:XML;
		//private var loadBar:MovieClip = new Loading();
		private var container:MovieClip = new MovieClip();
		private var sources:Array;	//holds all imported files
		private var touchRef = new TouchEvents(stage);
		
		public function Main() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//addChild(loadBar);
			addChild(container);
			container.y=100;
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			changeState("menu");
		}
		
		public function GetTouchRef() {
			return touchRef;
		}
		
		public function addToStage(object) {
			addChild(object);
		}
		
		public function XMLDone(xm) {
			xml = xm;
			trace(xml);
			xmlLoader.SetXML("music", "1");
			xmlLoader.Save(true);
			//menu.leaderboard.leaderName.text = "Name: "+xml.leaderboard.entry.@name;
			//menu.leaderboard.leaderScore.text = "Score: "+xml.leaderboard.score;
			//menu.leaderboard.leaderPlace.text = "Place: "+xml.leaderboard.entry.@place;
			//trace("Name: "+xml.leaderboard.entry.@name+", Score: "+xml.leaderboard.score+", Place:"+xml.leaderboard.entry.@place);
		}
		
		public function fileLoaded(file) {
			trace(file.GetType()+":"+file.GetName()+" done loading");
			if (file.GetType() != "sound") {container.addChild(file.GetObject())};
			if (xmlLoader.AllFilesLoaded()) {
				//removeChild(loadBar);
				trace("all files have finished loading");
				trace(GetSource("backer").GetURL());
			}
		}
		
		public function setSources(arr) {
			sources = arr;
		}
		
		public function GetSource(name:String=null) {
			if (name != null) {
				if (sources[name] !== undefined) {
					return sources[name];
				}
				else {
					trace("key is not defined");
					return null;
				}
			}
			else {
				return sources;
			}
		}
		
		public function GetXML() {
			return xml;
		}
		
		private function getData(e:Event) {
			xml = xmlLoader.Data();
		}
		
		public function updateLoadBar(loaded,total) {
			//loadBar.loadBar.width = (loaded/total)*loadBar.loadOutline.width;
			//loadBar.loadText.text = new uint(loaded/total*100).toString()+"%";
		}
		
		public function removeFromStage(object) {
			removeChild(object);
		}
		
		public function changeState(stat:String) {
			if (cState) {removeChild(cState);}
			switch(stat) {
				case "intro":
					intro = new Intro();
					break;
				case "menu":
					menu = new Menu();
					break;
				case "game":
					game = new Game(this);
					break;
				case "settings":
					settings = new Settings(this);
					break;
			}
			cState = this[stat];
			addChild(cState);
		}
	}
}
