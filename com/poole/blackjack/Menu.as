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
			
			main=MovieClip(this.parent);
			TweenPlugin.activate([AutoAlphaPlugin]);
			TweenLite.to(black,2,{autoAlpha:0});
		}
		
		private function playClick(e:MouseEvent) {
			main.changeState("game");
		}
		
		private function settingsClick(e:MouseEvent) {
			main.changeState("settings");
		}
		
		private function over(e:MouseEvent) {
			Mouse.cursor="button";
		}
		
		private function out(e:MouseEvent) {
			Mouse.cursor="auto";
		}
	}
	
}
