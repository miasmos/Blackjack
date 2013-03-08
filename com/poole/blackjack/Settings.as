package com.poole.blackjack {
	import flash.display.MovieClip;
	import flash.events.*;

	public class Settings extends MovieClip {
		private var main;
		
		public function Settings(mai) {
			main = mai;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			btnSound.addEventListener(MouseEvent.CLICK, soundClick);
		}
		
		private function soundClick(e:MouseEvent) {
			btnSound.setStyle("icon",SoundOn);
			var music = main.GetSource("music");
			if (music.IsPlaying()) {
				music.Stop();
			}
			else {
				music.Play();
			}
		}
		
	}
	
}
