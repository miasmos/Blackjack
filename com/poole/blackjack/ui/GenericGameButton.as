package com.poole.blackjack.ui {
	import flash.display.SimpleButton;
	
	public class GenericGameButton extends SimpleButton {
		public function GenericGameButton() {
			// constructor code
		}
		
		function Toggle(stat) {
			this.mouseEnabled = stat;
			this.enabled = stat;
		}
	}
	
}
