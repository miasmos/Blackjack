package com.poole.blackjack {
	import flash.events.*;
	import flash.display.MovieClip;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.ui.Mouse;
	import com.poole.blackjack.helper.VideoControl;
	
	public class Intro extends MovieClip {
		private var main;
		private var video:VideoControl;
		
		public function Intro() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, loadChk);
		}
		
		private function init(e:Event) {
			main=MovieClip(this.parent);
			removeEventListener(Event.ADDED_TO_STAGE, init);
			btnSkip.addEventListener(MouseEvent.CLICK, skipClick);
			btnSkip.addEventListener(MouseEvent.ROLL_OVER, skipOver);
			btnSkip.addEventListener(MouseEvent.ROLL_OUT, out);
		
			//TweenPlugin.activate([AutoAlphaPlugin]);
			/*TweenLite.to(black,2,{autoAlpha:0});
			TweenLite.to(black,2,{autoAlpha:1,delay:4,onComplete:function() {
				main.changeState("menu"); 
			}});*/
			
		}
		
		private function loadChk(e:Event) {
			if (main.GetSource("logo") !== null) {
				if (main.GetSource("logo").Loaded()) {
					trace("video loaded lol");
					removeEventListener(Event.ENTER_FRAME, loadChk);
					video = main.GetSource("logo").GetThis();
					this.addChild(video);
					video.Start(stage.stageWidth*0.7);
					addEventListener(Event.ENTER_FRAME, doneChk);
				}
			}
		}
		
		private function doneChk(e:Event) {
			if (video.IsDone()) {
				removeEventListener(Event.ENTER_FRAME, doneChk);
				main.changeState("menu");
			}
		}
		
		private function skipClick(e:MouseEvent) {
			//TweenLite.killTweensOf(black);
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
