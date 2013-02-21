package com.poole.blackjack {
	import flash.events.*;
	import flash.display.MovieClip;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.ui.Mouse;
	
	public class Intro extends MovieClip {
		private var main;
		
		public function Intro() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			btnSkip.addEventListener(MouseEvent.CLICK, skipClick);
			btnSkip.addEventListener(MouseEvent.ROLL_OVER, skipOver);
			btnSkip.addEventListener(MouseEvent.ROLL_OUT, out);
			
			main=MovieClip(this.parent);
			TweenPlugin.activate([AutoAlphaPlugin]);
			TweenLite.to(black,2,{autoAlpha:0});
			TweenLite.to(black,2,{autoAlpha:1,delay:4,onComplete:function() {
				main.changeState("menu"); 
			}});
		}
		
		private function skipClick(e:MouseEvent) {
			TweenLite.killTweensOf(black);
			main.changeState("menu");
		}
		
		private function skipOver(e:MouseEvent) {
			Mouse.cursor="button";
		}
		
		private function out(e:MouseEvent) {
			Mouse.cursor="auto";
		}
	}
	
}
