package com.poole.blackjack {
	import com.poole.blackjack.Deck;
	import com.poole.blackjack.Player;
	import com.poole.blackjack.Computer;
	import com.poole.blackjack.ui.Chip;
	import com.poole.blackjack.ui.ChipUI;
	import com.poole.blackjack.ui.Pot;
	import com.poole.blackjack.ui.CircleTimer;
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Mouse;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import flash.text.TextFormat;
	import com.poole.blackjack.TouchEvents;
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
		private var startChips:uint=0;	//number of chips player starts with
		private var splitArr:Array = new Array();
		private var main;	//ref to main
		private var forceDealerWin:Boolean=false;
		private var blackjack:Boolean=false;
		
		public function Game(m) {
			main = m;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loadSettings();
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
			
			buttonPanel.btnHit.addEventListener(MouseEvent.CLICK,Hit);
			buttonPanel.btnStay.addEventListener(MouseEvent.CLICK,Stay);
			buttonPanel.btnSurrender.addEventListener(MouseEvent.CLICK,Surrender);
			buttonPanel.btnDouble.addEventListener(MouseEvent.CLICK,Double);
			btnSettings.addEventListener(MouseEvent.CLICK, settingsClick);
			btnSettings.addEventListener(MouseEvent.ROLL_OVER, over);
			btnSettings.addEventListener(MouseEvent.ROLL_OUT, out);
			//buttonPanel.btnSplit.addEventListener(MouseEvent.CLICK,Split);
			addChild(player);
			addChild(computer);
			
			setChildIndex(chipUI,numChildren-1);
			setChildIndex(pot,numChildren-1);
			setChildIndex(player,0);
			setChildIndex(computer,0);
			
			trace(deck.Peek());
			setChildIndex(buttonPanel,numChildren-1);
			newHand();
		}
		
		private function loadSettings() {
			startChips = int(main.GetSetting("guest","chips"));
			if (startChips < 10) {startChips = 200;}
		}
		
		/*button actions*/
		private function Surrender(e:MouseEvent) {
			//surrender the hand, refund half the original bet
			playSound("click");
			pot.Award(pot.GetChips()/2);
			setTimeout(newHand,2000);
		}
		
		private function Double(e:MouseEvent) {
			//double the bet, get only one additional card
			//Toggle(buttonPanel.btnHit,false);
			//Toggle(buttonPanel.btnDouble,false);
			//Hit(null);
			//chipUI.SetChips(int(test.text));
			playSound("click");
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
			playSound("click");
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
			playSound("card",1,6);
			Toggle(buttonPanel.btnDouble,false);
			Toggle(buttonPanel.btnSurrender,false);
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
			if (chipUI.YouAreAFailure()) {
				trace("YOU ARE A LOSER");
				var broke = new Broke();
				addChild(broke);
				removeChild(chipUI);
				removeChild(pot);
				removeChild(buttonPanel);
				broke.btnMenu.addEventListener(MouseEvent.CLICK,function(e:MouseEvent){
					main.changeState("menu");
				});
				broke.btnMenu.addEventListener(MouseEvent.ROLL_OVER, over);
				broke.btnMenu.addEventListener(MouseEvent.ROLL_OUT, out);
				broke.x = 0;
				broke.y = stage.stageHeight/2-broke.height/2;
			}
			else {
				chipUI.Enable();
				TweenMax.to(buttonPanel,1,{y:950});
				TweenMax.to(placeBet,0.5,{autoAlpha:1});
				addChild(chipTimer);
				addEventListener(Event.ENTER_FRAME,checkBet);
			}
		}
		
		/*workhorse*/
		private function Winner() {
			DisableAllButtons();
			computer.FlipAll(true);
			
			if (!player.Bust()) {
				var tempCard=computer.GetLastPlayed();
				var ret=computer.Play();
				playSound("card",1,6);
	
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
					if (blackjack) {
						trace("Blackjack!");
						main.EditSetting("guest","chipswon",int(main.GetSetting("guest","chipswon"))+pot.GetChips()*2);
						main.EditSetting("guest","handswon",int(main.GetSetting("guest","handswon"))+1);
						pot.Award(pot.GetChips()*2.5);
					}
						else {
						if (computer.Bust()) {
							trace("Player wins!");
							main.EditSetting("guest","chipswon",int(main.GetSetting("guest","chipswon"))+pot.GetChips()*2);
							main.EditSetting("guest","handswon",int(main.GetSetting("guest","handswon"))+1);
							pot.Award(pot.GetChips()*2);
						}
						else {
							if (computer.GetTotal() > player.GetTotal() || forceDealerWin == true) {
								trace("Dealer wins!");
								main.EditSetting("guest","chipslost",int(main.GetSetting("guest","chipslost"))+pot.GetChips());
								main.EditSetting("guest","handslost",int(main.GetSetting("guest","handslost"))+1);
								pot.Award(0);
							}
							else if (computer.GetTotal() == player.GetTotal()) {
								trace("Push!");
								main.EditSetting("guest","handstied",int(main.GetSetting("guest","handstied"))+1);
								pot.Award(pot.GetChips());
							}
							else {
								trace("Player Wins!");
								main.EditSetting("guest","chipswon",int(main.GetSetting("guest","chipswon"))+pot.GetChips()*2);
								main.EditSetting("guest","handswon",int(main.GetSetting("guest","handswon"))+1);
								pot.Award(pot.GetChips()*2);
							}
						}
					}
				}
				else {
					trace("Player Busts.");
					main.EditSetting("guest","chipslost",int(main.GetSetting("guest","chipslost"))+pot.GetChips());
					main.EditSetting("guest","handslost",int(main.GetSetting("guest","handslost"))+1);
					pot.Award(0);
				}
			}
			SaveStats();
			main.EditSetting("guest","hands",int(main.GetSetting("guest","hands"))+1);
			main.Save(null);
			forceDealerWin=false;
			blackjack=false;
			setTimeout(newHand,2000);
		}
		
		private function checkBet(e:Event) {
			if ((pot.GetChips() < minBet && chipTimer.IsDone())) {	//bet minimum amount on timer end and no bets
				chipUI.ManualAdd(minBet-pot.GetChips());
				removeEventListener(Event.ENTER_FRAME,checkBet);
			}
			
			if ((pot.GetChips() >= minBet || chipUI.GetChips() < minBet) && chipTimer.IsDone()) {
				chipUI.Disable();
				TweenMax.to(buttonPanel,1,{y:880});
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
			TweenMax.to(placeBet,0.5,{autoAlpha:0});
			chipTimer = null;
			
			player.visible = true;
			computer.visible = true;
			player.Hit();
			computer.Hit();
			player.Hit();
			//deck.draw(*flipped, *moveable, *give specific card)
			computer.Hit(false,false,null);
			playSound("shuffle");
			trace("Player Total:"+player.GetTotal());
			
			if (player.GetTotal() == 21 && computer.GetTotal() < 21) {
				trace("blackjack!");
				blackjack=true;
				Winner();
				return;
			}
			else if (player.GetTotal() == 21 && computer.GetTotal() == 21) {
				Winner();
				return;
			}
			
			if (computer.GetTotal() != 21) {
				Toggle(buttonPanel.btnSurrender,true);
			}
			else {
				trace("dealer blackjack!");
				forceDealerWin=true;
				return;
			}
			
			//if (player.CanSplit()) {Toggle(buttonPanel.btnSplit,true);}
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
			if (chipTimer == null && !chipUI.YouAreAFailure()) {chipTimer = new CircleTimer();}
		}
		
		public function SaveStats() {
			main.EditSetting("guest","winpercentage",(int(main.GetSetting("guest","handswon"))/int(main.GetSetting("guest","hands"))*100).toFixed(1));
			main.EditSetting("guest","chips",chipUI.GetChips());
		}
		
		/*helper functions*/
		private function EnableAllButtons() {
			Toggle(buttonPanel.btnSurrender,true);
			Toggle(buttonPanel.btnHit,true);
			Toggle(buttonPanel.btnStay,true);
			Toggle(buttonPanel.btnDouble,true);
		}
		
		private function DisableAllButtons() {
			Toggle(buttonPanel.btnSurrender,false);
			Toggle(buttonPanel.btnHit,false);
			Toggle(buttonPanel.btnStay,false);
			Toggle(buttonPanel.btnDouble,false);
		}
		
		private function Toggle(object,stat) {
			object.mouseEnabled = stat;
			//object.mouseChildren = stat;
			object.enabled = stat;
			TweenMax.to(object,0.5,{alpha:stat});
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
			if (chipTimer) {chipTimer.Reset();}
		}
		
		private function enumHands() {
			splitArr.reverse();
			for (var i:uint=0;i<splitArr.length;i++) {
				if (!splitArr[i].IsDone()) {trace("next hand at:"+(splitArr.length-i).toString()+",arr length:"+splitArr.length); splitArr.reverse(); return splitArr.length-1-i;}
			}
			return -1;
		}
		
		public function playSound(key:String,low:int=0,high:int=0) {
			if (low >0 && high > 0) {
				main.GetRandomSound(key,low,high).Play();
			}
			else {
				main.GetSource(key).Play();
			}
		}
		
		private function out(e:MouseEvent) {
			Mouse.cursor="auto";
		}
		
		private function settingsClick(e:MouseEvent) {
			main.changeState("settings",false);
		}
		
		private function over(e:MouseEvent) {
			Mouse.cursor="button";
		}
	}
}


