package com.poole.blackjack {
	import flash.display.MovieClip;
		import com.greensock.*;
	import com.greensock.easing.*;

	public class Indicator extends MovieClip {
		public function Indicator(vis:Boolean=true,siz:Number=1,init:String="") {
			if (init.length > 0) {Text.text = init;}
			if (!vis) {Hide();}
			else {Show();}
			this.scaleX = siz;
			this.scaleY = siz;
		}
		
		public function Update(txt:String) {
			Text.text = txt;
		}
		
		public function GetText() {
			return Text.text;
		}
		
		public function Toggle() {
			this.visible = !this.visible;
			this.mouseEnabled = !this.mouseEnabled;
			this.mouseChildren = !this.mouseChildren;
		}
		
		public function Hide() {
			TweenMax.to(this,0.5,{alpha:0});
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function Show() {
			TweenMax.to(this,0.5,{alpha:1});
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		public function IsHidden() {
			return !this.visible;
		}
		
		public function HasText() {
			return Text.text.length > 0;
		}
		
		public function Resize(siz:Number) {
			this.scaleX = siz;
			this.scaleY = siz;
		}
	}
}