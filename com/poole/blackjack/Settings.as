package com.poole.blackjack {
	import flash.display.MovieClip;
	import flash.events.*;

	public class Settings extends MovieClip {
		private var main;
		private var music;
		
		public function Settings(mai) {
			main = mai;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			muteButton.addEventListener(MouseEvent.CLICK, mute);
			playButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {controls(e,true);});
			stopButton.addEventListener(MouseEvent.CLICK, function(e:MouseEvent) {controls(e,false);});
			music = main.GetSource("music");
			if (music.IsPlaying()) {playButton.gotoAndStop("Pause")}
			else {playButton.gotoAndStop("Play");}
			if (music.IsMuted()) {muteButton.gotoAndStop("Muted")}
			else {muteButton.gotoAndStop("Unmuted");}
		}
		
		private function mute(e:MouseEvent) {
			music.Mute();
			if (music.IsMuted()) {muteButton.gotoAndStop("Muted");}
			else {muteButton.gotoAndStop("Unmuted");}
		}
		
		private function controls(e:MouseEvent,func:Boolean) {
			if (func) {	//play/pause
				music.Toggle();
				if (music.IsPlaying()) {playButton.gotoAndStop("Pause");}
				else {playButton.gotoAndStop("Play");}
			}
			else {	//stop
				music.Stop();
				playButton.gotoAndStop("Play");
			}
		}
	}
}
