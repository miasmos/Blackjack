package com.poole.blackjack {
	import flash.display.MovieClip;
	import flash.events.*;
	import com.greensock.*;
	import com.greensock.easing.*;

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
			backing.addEventListener(MouseEvent.CLICK, closeMe);
			music = main.GetSource("music");
			if (music.IsPlaying()) {playButton.gotoAndStop("Pause")}
			else {playButton.gotoAndStop("Play");}
			if (music.IsMuted()) {muteButton.gotoAndStop("Muted")}
			else {muteButton.gotoAndStop("Unmuted");}
			populateStats();
		}
		
		private function mute(e:MouseEvent) {
			music.Mute();
			if (music.IsMuted()) {muteButton.gotoAndStop("Muted");	main.EditSetting("settings","music",0);}
			else {muteButton.gotoAndStop("Unmuted");	main.EditSetting("settings","music",1);}
			main.GetSource("click").Play();
		}
		
		private function controls(e:MouseEvent,func:Boolean) {
			if (func) {	//play/pause
				music.Toggle();
				if (music.IsPlaying()) {playButton.gotoAndStop("Pause");	main.EditSetting("settings","music",0);}
				else {playButton.gotoAndStop("Play");	main.EditSetting("settings","music",1);}
			}
			else {	//stop
				music.Stop();
				playButton.gotoAndStop("Play");
				main.EditSetting("settings","music",0);
			}
			main.GetSource("click").Play();
		}
		
		private function closeMe(e:MouseEvent) {
			main.Save(null);
			TweenMax.to(this,1,{alpha:0,onCompleteParams:[this],onComplete:function(tar) {
				main.removeFromStage(tar);
			}});
		}
		
		private function populateStats() {
			chips.text = "Current Chips: "+main.GetSetting("guest","chips");
			chipswon.text = "Chips Won: "+main.GetSetting("guest","chipswon");
			chipslost.text = "Chips Lost: "+main.GetSetting("guest","chipslost");
			hands.text = "Hands: "+main.GetSetting("guest","hands");
			handswon.text = "Hands Won: "+main.GetSetting("guest","handswon");
			handslost.text = "Hands Lost: "+main.GetSetting("guest","handslost");
			handstied.text = "Hands Tied: "+main.GetSetting("guest","handstied");
			winpercentage.text = "Win Percentage: "+main.GetSetting("guest","winpercentage")+"%";
		}
	}
}
