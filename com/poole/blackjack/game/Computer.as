package com.poole.blackjack.game {
	import com.poole.blackjack.game.Player;
	import flash.events.*;
	
	public class Computer extends Player {
		public function Computer(gameRef=null,deckRef=null) {
			deck=deckRef;
			game=gameRef;
		}
		
		public function Play() {
			var hitCards:Array = new Array();
			trace("Dealer Total:"+GetTotal());
			for (var i:uint=0;i<=13;i++) {
				if (total < 17 || total == 17 && aceCount > 0) {
					Hit();
					hitCards.push(GetLastPlayed());
					trace("Dealer Hits:"+GetTotal());
				}
				else if (total > 21) {
					trace("Dealer bust");
					break;
				}
				else {
					trace("Dealer stays");
					break;
				}
			}
			if (hitCards.length > 0) {
				return hitCards;
			}
			else {
				return 1;
			}
		}
		
		override public function Reset() {
			this.y=50;
			total = 0;
			aceCount = 0;
			
			for each (var index in cards) {
				removeChild(index);
			}
			cards = new Array();
		}
	}
}
