package com.poole.blackjack.game {
	import flash.events.*;
	import flash.display.MovieClip;

	public class Player extends MovieClip {
		var cards:Array = new Array();
		var total:uint = 0;
		var playerID:String;
		var aceCount:uint = 0;
		var deck:Deck;
		var game;
		var chips:uint=10000;
		var spaceBetweenCards:Number=50;
		
		public function Player(gameRef=null,deckRef=null) {
			deck=deckRef;
			game=gameRef;
		}
		
		public function Hit(flipped:Boolean=true,allowMove:Boolean=false,give:String=null) {
			var card=deck.Draw(flipped,allowMove,give);
			card.SetOwner(playerID);
			if (card.DisplayValue() == "A") {aceCount+=1;}
			cards.push(card);
			total+=card.NumericValue();
			
			if (aceCount>0 && total>21) {
				total-=10;
				aceCount-=1;
			}
			
			centerObjects();
			this.addChild(card);
		}
		
		public function FlipAll(stat:Boolean=true) {
			for each (var index in cards) {
				index.Flip(stat);
			}
		}
		
		public function Bust() {
			return total>21;
		}
		
		public function Reset() {
			this.y=game.uiZone.y-50-deck.CardProps().height;
			total = 0;
			aceCount = 0;
			
			for each (var index in cards) {
				removeChild(index);
			}
			cards = new Array();
		}
		
		public function GetCards() {
			return cards;
		}
		
		public function GetTotal() {
			return total;
		}
		
		public function GetLastPlayed() {
			return cards[cards.length-1];
		}
		
		public function GetName() {
			return playerID;
		}
		
		public function GetChips() {
			return chips;
		}
		
		public function SetChips(amt:uint) {
			chips=amt;
		}
		
		private function centerObjects() {
			var temp:Number=cards[0].width;
			cards[0].x=0;
			if (cards.length > 1) {
				for (var i:uint=1; i <= cards.length-1; i++) {
					cards[i].x=cards[i-1].x+spaceBetweenCards;
					temp+=spaceBetweenCards;
				}
			}

			this.x=game.width/2-this.width/2;
			trace(game.width/2+"-"+this.width/2+"="+(game.width/2-this.width/2)+","+this.x);
		}
	}
}