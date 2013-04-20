package com.poole.blackjack {
	import flash.display.MovieClip;

	public class IndicatorLong extends Indicator {
		public function IndicatorLong(vis:Boolean=true,siz:Number=1,init:String="") {
			if (init.length > 0) {Text1.text = init;}
			if (!vis) {Hide();}
			else {Show();}
			this.scaleX = siz;
			this.scaleY = siz;
		}
		
		override public function Update(txt:String) {
			Text1.text = txt;
		}
		
		override public function GetText() {
			return Text1.text;
		}
	}
}