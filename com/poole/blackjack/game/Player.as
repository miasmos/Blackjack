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
		var ind = new Indicator(true,0.5,"0");
		
		public function Player(gameRef=null,deckRef=null) {
			deck=deckRef;
			game=gameRef;
			addChild(ind);
			ind.y = this.height/2-ind.height/2;
		}
		
		public function Hit(flipped:Boolean=true,allowMove:Boolean=false,give:String=null,updateInd:Boolean=true) {
			var card=deck.Draw(flipped,allowMove,give);
			card.SetOwner(playerID);
			if (card.DisplayValue() == "A") {aceCount+=1;}
			cards.push(card);
			total+=card.NumericValue();
			if (updateInd) {ind.Update(total.toString());}
			if (aceCount>0 && total>21) {
				total-=10;
				aceCount-=1;
			}
			
			centerObjects();
			this.addChild(card);
			ind.x = GetLastPlayed().x+GetLastPlayed().width-(ind.width/2);
			ind.y = this.height/2-ind.height/2;
			setChildIndex(ind,this.numChildren-1);
		}
		
		public function FlipAll(stat:Boolean=true) {
			for each (var index in cards) {
				index.Flip(stat);
				if (stat) {ind.Update(total);}
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

			this.x=stage.stageWidth/2-(cards[0].width+(spaceBetweenCards*(cards.length-1)))/2;
			trace(this.x);
		}
	}
}