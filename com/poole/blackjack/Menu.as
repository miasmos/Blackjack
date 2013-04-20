package com.poole.blackjack {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.ui.Mouse;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	public class Menu extends MovieClip{
		private var main;
		
		public function Menu() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			btnPlay.addEventListener(MouseEvent.CLICK, playClick);
			btnPlay.addEventListener(MouseEvent.ROLL_OVER, over);
			btnPlay.addEventListener(MouseEvent.ROLL_OUT, out);
			btnSettings.addEventListener(MouseEvent.CLICK, settingsClick);
			btnSettings.addEventListener(MouseEvent.ROLL_OVER, over);
			btnSettings.addEventListener(MouseEvent.ROLL_OUT, out);
			btnSettings1.addEventListener(MouseEvent.CLICK, settingsClick);
			btnSettings1.addEventListener(MouseEvent.ROLL_OVER, over);
			btnSettings1.addEventListener(MouseEvent.ROLL_OUT, out);
			
			main=MovieClip(this.parent);
			main.GetSource("music").Play();
			if (int(main.GetSetting("settings","music")) == 0) {main.GetSource("music").Mute();}
			TweenPlugin.activate([AutoAlphaPlugin]);
			TweenLite.to(black,2,{autoAlpha:0});
			trace(int(main.GetSetting("guest","chips")));
			if (int(main.GetSetting("guest","chips")) >= 10) {btnPlay.textbox.text = "Continue";}
			else {btnPlay.textbox.text = "New Game";}
		}
		
		private function playClick(e:MouseEvent) {
			main.GetSource("click").Play();
			main.changeState("game");
		}
		
		private function settingsClick(e:MouseEvent) {
			main.GetSource("click").Play();
			main.changeState("settings",false);
		}
		
		private function over(e:MouseEvent) {
			Mouse.cursor="button";
		}
		
		private function out(e:MouseEvent) {
			Mouse.cursor="auto";
		}
	}
	
}
