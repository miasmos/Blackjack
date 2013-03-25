package com.poole.blackjack {
	import com.poole.blackjack.game.Deck;
	import com.poole.blackjack.game.Player;
	import com.poole.blackjack.game.Computer;
	import com.poole.blackjack.ui.Chip;
	import com.poole.blackjack.ui.ChipUI;
	import com.poole.blackjack.ui.Pot;
	import com.poole.blackjack.ui.CircleTimer;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.text.TextFormat;
	import com.poole.blackjack.game.TouchEvents;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class Game extends MovieClip {
		private var deck:Deck;
		private var player:Player;
		private var computer:Computer;
		private var chipUI:ChipUI;
		private var pot:Pot;
		private var chipTimer;
		private var cardSize=1;	//size of cards, multiplicative ex. 2 = double size
		private var minBet=20;	//minimum bet to play a hand
		private var startChips=140;	//number of chips player starts with
		private var splitArr:Array = new Array();
		private var main;	//ref to main
		
		public function Game(m) {
			main = m;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			deck = new Deck(this,cardSize);
			player = new Player(this,deck);
			splitArr.push(player);
			computer = new Computer(this,deck);
			pot = new Pot(this);
			chipUI = new ChipUI(this,pot,startChips);
			pot.SetChipUI(chipUI);
			
			//var touchRef = parent.GetTouchRef();
			//main.GetTouchRef().addEventListener("Tap", Hit);
			//main.GetTouchRef().addEventListener("SwipeLeft", Stay);
			//main.GetTouchRef().addEventListener("SwipeRight", Stay);
			
			btnHit.addEventListener(MouseEvent.CLICK,Hit);
			btnStay.addEventListener(MouseEvent.CLICK,Stay);
			btnSurrender.addEventListener(MouseEvent.CLICK,Surrender);
			btnDouble.addEventListener(MouseEvent.CLICK,Double);
			btnSplit.addEventListener(MouseEvent.CLICK,Split);
			addChild(player);
			addChild(computer);
			
			setChildIndex(chipUI,numChildren-1);
			setChildIndex(pot,numChildren-1);
			setChildIndex(player,0);
			setChildIndex(computer,0);
			
			trace(deck.Peek());
			newHand();
		}
		
		/*button actions*/
		private function Surrender(e:MouseEvent) {
			//surrender the hand, refund half the original bet
			pot.Award(pot.GetChips()/2);
			setTimeout(newHand,2000);
		}
		
		private function Double(e:MouseEvent) {
			//double the bet, get only one additional card
			//Toggle(btnHit,false);
			//Toggle(btnDouble,false);
			//Hit(null);
			//chipUI.SetChips(int(test.text));
			
			chipUI.ManualAdd(pot.GetChips());
			player.Hit();
			Winner();
			setTimeout(newHand,4000);
		}
		
		private function Split(e:MouseEvent) {
			//split pairs, each becoming a new hand
			if (player.CanSplit()) {
				var tmp = new Player(this,deck);
				splitArr.push(tmp);
				player.ChangeOwner("last",tmp);	//transfer last card to new player instance
				addChild(tmp);
				for (var i=0;i<splitArr.length;i++) {
					splitArr[i].y = this.y;
					splitArr[i].x = i*200;
				}
				player = tmp;
			}
		}
		
		private function Stay(e:Event) {
			trace("Player stays");
			player.Done();
			if (!SplitExists()) {
				Winner();
			}
			else {
				player = splitArr[enumHands()];
			}
		}
		
		private function Hit(e:Event) {
			Toggle(btnDouble,false);
			Toggle(btnSurrender,false);
			if (!deck.CardsLeft()) {deck.Reset();}
			trace("cards left:"+deck.CardsLeft());
			var tempCard=player.GetLastPlayed();
			player.Hit();
			player.GetLastPlayed().x=tempCard.x+50;
			player.GetLastPlayed().y=tempCard.y;
			trace("Player Hits:"+player.GetTotal());
			
			if (player.Bust()) {
				player.Done();
				
				if (SplitExists()) {
					player = splitArr[enumHands()];
				}
				else {
					Winner();
				}
			}
		}
		
		private function newHand() {
			Reset();
			chipUI.Enable();
			addChild(chipTimer);
			addEventListener(Event.ENTER_FRAME,checkBet);
		}
		
		/*workhorse*/
		private function Winner() {
			Toggle(btnHit,false);
			Toggle(btnStay,false);
			Toggle(btnDouble,false);
			computer.FlipAll(true);
			
			if (!player.Bust()) {
				var tempCard=computer.GetLastPlayed();
				var ret=computer.Play();
	
				if (typeof(ret) == "object") {	//returned new cards
					for each (var index in ret) {
						index.x=tempCard.x+50;
						index.y=tempCard.y;
						tempCard=index;
					}
				}
			}
			
			setTimeout(continueWinner,2000);
		}
		
		private function continueWinner() {
			for (var i:uint=0; i < splitArr.length; i++) {
				trace("hand "+i);
				if (!splitArr[i].Bust()) {
					trace("\nPlayer: "+player.GetTotal()+" Dealer: "+computer.GetTotal());
					if (computer.Bust()) {
						trace("Player wins!");
						pot.Award(pot.GetChips()*2);
					}
					else {
						if (computer.GetTotal() > player.GetTotal()) {
							trace("Dealer wins!");
							pot.Award(0);
						}
						else if (computer.GetTotal() == player.GetTotal()) {
							trace("Push!");
							pot.Award(pot.GetChips());
						}
						else {
							trace("Player Wins!");
							pot.Award(pot.GetChips()*2);
						}
					}
				}
				else {
					trace("Player Busts.");
					pot.Award(0);
				}
			}
			setTimeout(newHand,2000);
		}
		
		private function checkBet(e:Event) {
			if ((pot.GetChips() < minBet && chipTimer.IsDone()) || chipUI.GetChips() < minBet) {	//bet minimum amount on timer end and no bets
				chipUI.ManualAdd(minBet-pot.GetChips());
				removeEventListener(Event.ENTER_FRAME,checkBet);
			}
			
			if (pot.GetChips() >= minBet && chipTimer.IsDone()) {
				chipUI.Disable();
				EnableAllButtons();
				removeEventListener(Event.ENTER_FRAME,checkBet);
				continueHand();
			}
			else {
				DisableAllButtons();
			}
		}
		
		private function continueHand() {
			removeChild(chipTimer);
			chipTimer = null;
			
			player.visible = true;
			computer.visible = true;
			player.Hit();
			computer.Hit();
			player.Hit();
			//deck.draw(*flipped, *moveable, *give specific card)
			computer.Hit(false,false,null);
			trace("Player Total:"+player.GetTotal());
			
			if (player.GetTotal() == 21 && computer.GetTotal() < 21) {
				trace("blackjack!");
				setTimeout(newHand,4000);
				pot.Award(pot.GetChips()*2);
				return;
			}
			else if (player.GetTotal() == 21 && computer.GetTotal() == 21) {
				computer.FlipAll(true);
				trace("Push!");
				setTimeout(newHand,4000);
				pot.Award(pot.GetChips());
				return;
			}
			
			if (computer.GetTotal() != 21) {
				Toggle(btnSurrender,true);
			}
			else {
				computer.FlipAll(true);
				Toggle(btnSurrender,false);
			}
			
			if (player.CanSplit()) {Toggle(btnSplit,true);}
		}
		
		private function Reset() {
			player = splitArr[0];
			for (var i:uint = 0; i<splitArr.length; i++) {
				splitArr[i].Reset();
				if (i != 0) {removeChild(splitArr[i]); splitArr.pop();}
			}
			computer.Reset();
			deck.Reset();
			player.visible = false;
			computer.visible = false;
			if (chipTimer == null) {chipTimer = new CircleTimer();}
		}
		
		/*helper functions*/
		private function EnableAllButtons() {
			Toggle(btnSurrender,true);
			Toggle(btnHit,true);
			Toggle(btnStay,true);
			Toggle(btnDouble,true);
		}
		
		private function DisableAllButtons() {
			Toggle(btnSurrender,false);
			Toggle(btnHit,false);
			Toggle(btnStay,false);
			Toggle(btnDouble,false);
		}
		
		function Toggle(object,stat) {
			object.mouseEnabled = stat;
			//object.mouseChildren = stat;
			object.enabled = stat;
			object.visible = stat;
		}
		
		private function SplitExists() {
			return enumHands() > -1;
		}
		
		private function centerObjects(obj:Array,space:uint=50) {
			var temp:Number=0;
			for (var i:uint=0; i <= obj.length; i++) {
				temp+=obj[i].width;
			}
			var totalY = temp*(obj.length+space);
			obj[0].x=stage.width/2-totalY/2;
			for (i=1; i<= obj.length; i++) {
				obj[i].x=obj[i-1].x+space;
			}
		}
		
		public function ResetTimer() {
			chipTimer.Reset();
		}
		
		private function enumHands() {
			splitArr.reverse();
			for (var i:uint=0;i<splitArr.length;i++) {
				if (!splitArr[i].IsDone()) {trace("next hand at:"+(splitArr.length-i).toString()+",arr length:"+splitArr.length); splitArr.reverse(); return splitArr.length-1-i;}
			}
			return -1;
		}
	}
}


