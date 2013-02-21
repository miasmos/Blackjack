package com.poole.blackjack {
	import flash.display.MovieClip;
	import flash.display.StageScaleMode;
	import com.poole.blackjack.helper.HandleXML;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class Main extends MovieClip {
		private var game:MovieClip;	//pass stage ref
		private var intro:MovieClip;
		private var menu:MovieClip;
		private var cState;	//state of app
		//private var xmlLoader:HandleXML = new HandleXML(this,'embed/data.void');
		private var xmlLoader:HandleXML = new HandleXML(this,'data',false);
		private var xml:XML;
		private var loadBar:MovieClip = new Loading();
		private var container:MovieClip = new MovieClip();
		
		public function Main() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			addChild(loadBar);
			addChild(container);
			container.y=100;
			//changeState("game");
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
			trace(file["type"]+":"+file["name"]+" done loading");
			container.addChild(file["object"]);
			if (xmlLoader.AllFilesLoaded()) {
				//removeChild(loadBar);
				trace("all files have finished loading");
				trace(xmlLoader.GetSource("backer","url"));
			}
		}
		
		public function GetXML() {
			return xml;
		}
		
		public function updateLoadBar(loaded,total) {
			loadBar.loadBar.width = (loaded/total)*loadBar.loadOutline.width;
			loadBar.loadText.text = new uint(loaded/total*100).toString()+"%";
		}
		
		public function removeFromStage(object) {
			removeChild(object);
		}
		
		private function getData(e:Event) {
			xml = xmlLoader.Data();
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
					game = new Game();
					break;
			}
			cState = this[stat];
			addChild(cState);
		}
	}
}
