package com.poole.blackjack.game {
	import flash.events.*;
	import flash.display.MovieClip;
	import com.poole.blackjack.Game;

	public class Player extends MovieClip {
		var cards:Array = new Array();
		var total:uint = 0;
		var playerID:String;
		var aceCount:uint = 0;
		var deck:Deck;
		var chips:uint=10000;
		var spaceBetweenCards:Number=50;
		
		public function Player(deckRef=null,id:String="Player") {
			deck=deckRef;
			playerID=id;
		}
		
		public function Hit(flipped:Boolean=true,allowMove:Boolean=false,size:Number=1,give:String=null) {
			var card=deck.Draw(flipped,allowMove,size,give);
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
			for (var i:uint=1; i <= cards.length; i++) {
				cards[i]=cards[i-1]+spaceBetweenCards;
				temp+=spaceBetweenCards;
			}
			
			this.x=stage.width/2-temp/2;
		}
	}
}