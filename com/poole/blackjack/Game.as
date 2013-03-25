package com.poole.blackjack {
	import com.poole.blackjack.game.Deck;
	import com.poole.blackjack.game.Player;
	import com.poole.blackjack.game.Computer;
	import com.poole.blackjack.ui.Chip;
	import com.poole.blackjack.ui.ChipUI;
	import com.poole.blackjack.ui.Pot;
	import com.poole.blackjack.ui.CircleTimer;
	import com.poole.blackjack.game.TouchEvents;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	public class Game extends MovieClip {
		var deck:Deck;
		var player:Player;
		var computer:Computer;
		var chipUI:ChipUI;
		var pot:Pot;
		var chipTimer;
		var cardSize=1;	//size of cards, multiplicative ex. 2 = double size
		var minBet=20;	//minimum bet to play a hand
		var startChips=100;	//number of chips player starts with
		var splitArr:Array = new Array();
		//var touchRef = new TouchEvents(gestureZone);
		
		public function Game() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//TweenPlugin.activate([AutoAlphaPlugin, VisiblePlugin]);
			
			//touchRef.addEventListener(TouchEventTap.TAP, LangSelected);
			//touchRef.addEventListener(TouchSwipeRight.SWIPE_RIGHT, ENtoPL);
			//touchRef.addEventListener(TouchSwipeLeft.SWIPE_LEFT, PLtoEN);
			
			deck = new Deck(this,cardSize);
			player = new Player(this,deck);
			splitArr.push(player);
			computer = new Computer(this,deck);
			pot = new Pot(this);
			chipUI = new ChipUI(this,pot,startChips);
			pot.SetChipUI(chipUI);
			setChildIndex(chipUI,numChildren-1);
			
			btnHit.addEventListener(MouseEvent.CLICK,Hit);
			btnStay.addEventListener(MouseEvent.CLICK,Stay);
			btnSurrender.addEventListener(MouseEvent.CLICK,Surrender);
			btnDouble.addEventListener(MouseEvent.CLICK,Double);
			btnSplit.addEventListener(MouseEvent.CLICK,Split);
			addChild(player);
			addChild(computer);
			trace(deck.Peek());
			chipTimer = new CircleTimer();
			addChild(chipTimer);
			newHand();
			
			//player.SetChips(1050);
			//chipUI.SetChips(1050);
		}
		
		function newHand() {
			Reset();
			addEventListener(Event.ENTER_FRAME,checkBet);
		}
		
		function continueHand() {
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
				pot.Award(pot.GetChips()*2);
				setTimeout(newHand,2000);
				return;
			}
			else if (player.GetTotal() == 21 && computer.GetTotal() == 21) {
				computer.FlipAll(true);
				trace("Push!");
				pot.Award(pot.GetChips());
				setTimeout(newHand,2000);
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
		
		function checkBet(e:Event) {
			if (pot.GetChips() >= minBet) {
				EnableAllButtons();
				removeEventListener(Event.ENTER_FRAME,checkBet);
				continueHand();
			}
			else {
				DisableAllButtons();
			}
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
		}
		
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
		
		function Hit(e:Event) {
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
		
		private function SplitExists() {
			return enumHands() > -1;
		}
		
		private function Winner() {
			Toggle(btnHit,false);
			Toggle(btnStay,false);
			Toggle(btnDouble,false);
			computer.FlipAll(true);
			
			for (var i:uint=0; i < splitArr.length; i++) {
				trace("hand "+i);
				if (!splitArr[i].Bust()) {
					var tempCard=computer.GetLastPlayed();
					var ret=computer.Play();
		
					if (typeof(ret) == "object") {	//returned new cards
						for each (var index in ret) {
							index.x=tempCard.x+50;
							index.y=tempCard.y;
							tempCard=index;
						}
					}
					
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
		
		function Stay(e:Event) {
			trace("Player stays");
			player.Done();
			if (!SplitExists()) {
				Winner();
			}
			else {
				player = splitArr[enumHands()];
			}
		}
		
		function Surrender(e:MouseEvent) {
			//surrender the hand, refund half the original bet
			pot.Award(pot.GetChips()/2);
			setTimeout(newHand,2000);
		}
		
		function Double(e:MouseEvent) {
			//double the bet, get only one additional card
			//Toggle(btnHit,false);
			//Toggle(btnDouble,false);
			//Hit(null);
			//chipUI.SetChips(int(test.text));
			chipUI.Award(5045);
		}
		
		function Split(e:MouseEvent) {
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
		
		function Toggle(object,stat) {
			object.mouseEnabled = stat;
			//object.mouseChildren = stat;
			object.enabled = stat;
		}

		/*touch/gesture functions*/
		function onSwipe(e:TransformGestureEvent) {	//user swiped
			if (e.offsetY != -1 && e.offsetY != 1) {	//left-to-right,right-to-left = stay
				Stay(null);
			}
			else if (e.offsetY == 1 && e.offsetX != 1 && e.offsetX != -1){	//up-down = hit
				Hit(null);
			}
		}
		
		function onTap(e:TouchEvent) {
			Hit(null);
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


