package com.poole.blackjack {
	import com.poole.blackjack.game.Deck;
	import com.poole.blackjack.game.Player;
	import com.poole.blackjack.game.Computer;
	import com.poole.blackjack.ui.Chip;
	import com.poole.blackjack.ui.ChipUI;
	import com.poole.blackjack.game.TouchEvents;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
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
		//var touchRef = new TouchEvents(gestureZone);
		
		public function Game() {
			deck = new Deck(this);
			player = new Player(deck);
			computer = new Computer(deck);
			chipUI = new ChipUI(this,10450);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			//TweenPlugin.activate([AutoAlphaPlugin, VisiblePlugin]);
			
			//touchRef.addEventListener(TouchEventTap.TAP, LangSelected);
			//touchRef.addEventListener(TouchSwipeRight.SWIPE_RIGHT, ENtoPL);
			//touchRef.addEventListener(TouchSwipeLeft.SWIPE_LEFT, PLtoEN);
			
			btnHit.addEventListener(MouseEvent.CLICK,Hit);
			btnStay.addEventListener(MouseEvent.CLICK,Stay);
			btnSurrender.addEventListener(MouseEvent.CLICK,Surrender);
			btnDouble.addEventListener(MouseEvent.CLICK,Double);

			trace(deck.Peek());
			newHand();
			
			//player.SetChips(1050);
			//chipUI.SetChips(1050);
		}
		
		function newHand() {
			Toggle(btnSurrender,true);
			Toggle(btnHit,true);
			Toggle(btnStay,true);
			Toggle(btnDouble,true);
			player.Reset();
			computer.Reset();
			deck.Reset();
			clearTable();
			
			//deck.draw(*flipped, *moveable, *size, *give specific card)
			player.Hit();
			computer.Hit();
			player.Hit();
			computer.Hit(false,false,1,null);
			trace("Player Total:"+player.GetTotal());
			
			
			if (player.GetTotal() == 21 && computer.GetTotal() < 21) {
				trace("blackjack!");
				newHand();
			}
			else if (player.GetTotal() == 21 && computer.GetTotal() == 21) {
				computer.FlipAll(true);
				trace("Push!");
				newHand();
			}
			else if (computer.GetTotal() != 21) {
				btnSurrender.visible = true;
			}
			else if (computer.GetTotal() == 21) {
				computer.FlipAll(true);
				btnSurrender.visible = false;
			}
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
				trace("Player Busts");
				Toggle(btnHit,false);
				Toggle(btnStay,false);
				computer.FlipAll(true);
				setTimeout(newHand,2000);
			}
		}
		
		function Stay(e:Event) {
			Toggle(btnHit,false);
			Toggle(btnStay,false);
			Toggle(btnDouble,false);
			trace("Player stays");
			computer.FlipAll(true);
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
			}
			else {
				if (computer.GetTotal() > player.GetTotal()) {
					trace("Dealer wins!");
				}
				else if (computer.GetTotal() == player.GetTotal()) {
					trace("Push!");
				}
				else {
					trace("Player Wins!");
				}
			}
			setTimeout(newHand,2000);
		}
		
		function Surrender(e:MouseEvent) {
			//surrender the hand, refund half the original bet
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
		}
		
		function Toggle(object,stat) {
			object.mouseEnabled = stat;
			//object.mouseChildren = stat;
			object.enabled = stat;
		}
		
		function clearTable() {
			/*for each (var index in deck.GetPlayed()) {
				removeChild(index);
			}*/
			deck.ClearPlayed();
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
	}
}


