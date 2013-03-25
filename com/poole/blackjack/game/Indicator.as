package com.poole.blackjack.game {
	import flash.display.MovieClip;

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
		
		public function Toggle() {
			this.visible = !this.visible;
			this.mouseEnabled = !this.mouseEnabled;
			this.mouseChildren = !this.mouseChildren;
		}
		
		public function Hide() {
			this.visible = false;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function Show() {
			this.visible = true;
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