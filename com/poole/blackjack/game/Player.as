package com.poole.blackjack.game {
	import flash.events.*;
	import flash.display.MovieClip;
	import com.poole.blackjack.game.Player;
	import com.poole.blackjack.game.Deck;

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
		var done:Boolean = false;	//tracks if the hand has been completed, important when split hands are being processed
		var splitChild:Boolean = false;	//tracks if this player is being used as a split child
		
		public function Player(gameRef=null,deckRef=null) {
			deck=deckRef;
			game=gameRef;
			addChild(ind);
			ind.y = this.height/2-ind.height/2;
		}
		
		public function Hit(flipped:Boolean=true,allowMove:Boolean=false,give:String=null) {
			var card=deck.Draw(flipped,allowMove,give);
			card.SetOwner(playerID);
			if (card.DisplayValue() == "A") {aceCount+=1;}
			cards.push(card);
			if (aceCount>0 && total>21) {
				total-=10;
				aceCount-=1;
			}
			total+=card.NumericValue();
			if (flipped) {ind.Update(total.toString());}
			centerObjects();
			this.addChild(card);
			ind.x = GetLastPlayed().x+GetLastPlayed().width-(ind.width/2);
			ind.y = this.height/2-ind.height/2;
			setChildIndex(ind,this.numChildren-1);
		}
		
		public function ChangeOwner(inp:String,tmp) {
			if (inp == "last") {
				tmp.Give(GetLastPlayed());	//transfer split card from original player to new player
				total -= GetLastPlayed().NumericValue();
				ind.Update(total);
				RemoveLast();
				centerObjects();
			}
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
		
		public function CanSplit() {
			return true;//cards.length == 2 && cards[0].NumericValue() == cards[1].NumericValue();
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
		
		public function Give(card,flipped:Boolean=true,allowMove:Boolean=false) {
			card.SetOwner(playerID);
			if (card.DisplayValue() == "A") {aceCount+=1;}
			cards.push(card);
			if (aceCount>0 && total>21) {
				total-=10;
				aceCount-=1;
			}
			total+=card.NumericValue();
			if (flipped != card.Flipped()) {card.Flip(flipped);}
			if (allowMove != card.Moveable()) {card.toggleMove(true);}
			if (flipped) {ind.Update(total.toString());}
			//centerObjects();
			this.addChild(card);
			ind.x = GetLastPlayed().x+GetLastPlayed().width-(ind.width/2);
			ind.y = this.height/2-ind.height/2;
			setChildIndex(ind,this.numChildren-1);
		}
		
		public function RemoveLast() {
			//removeChild(GetLastPlayed());
			cards.pop();
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
		}
		
		public function IsDone() {
			return done;
		}
		
		public function Done() {
			done = true;
		}
		
		public function IsChild() {
			return splitChild;
		}
		
		public function Child() {
			splitChild = true;
		}
	}
}