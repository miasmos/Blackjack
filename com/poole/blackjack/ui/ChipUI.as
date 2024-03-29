﻿package com.poole.blackjack.ui {
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import com.poole.blackjack.IndicatorLong;
	import com.greensock.*;
	import com.greensock.easing.*;
	import fl.transitions.easing.*;
	import com.greensock.plugins.*;
	import com.poole.blackjack.ui.Pot;
	
	public class ChipUI extends MovieClip {
		private var chips:Array = [new Chip(10), new Chip(25), new Chip(100), new Chip(500), new Chip(1000)];
		private var game;	//reference to parent object
		private var playerChips:uint;	//number of chips the player has
		private var pot:Pot;
		private var dragRef;	//reference to the object spawned on drag
		private var originRef;	//reference to the origin of the spawned object
		private var fadingChips:TimelineLite;	//reference to fading animations
		private var movingChips:TimelineLite;	//reference to moving animations
		private var newXVal;	//destination of a chip denomination being added back to the chipUI
		private var fadeTime=0.3;	//time to fade in animations
		private var moveTime=0.7;	//time to move in animations
		private var chipsClickable:Boolean = true;	//determines whether or not the chips are clickable
		private var ind = new IndicatorLong(true,0.5,"0");	//chip count indicator
	
		public function ChipUI(g,p,initialChips:uint) {
			game=g;
			playerChips=initialChips;
			pot = p
			game.addChild(this);
			ind.Update(initialChips.toString());
			ind.x = -70;
			addChild(ind);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function SetChips(amt:uint) {
			ind.y = this.height/2-ind.height/2;
			playerChips=amt;
			Toggle(getChipDisplay());
		}
		
		public function AddToChips(amt:uint) {
			playerChips+=amt;
			Toggle(getChipDisplay());
		}
		
		public function GetChips() {
			return playerChips;
		}
		
		public function Award(amt:uint) {
			pot.Award(amt);
			pot.Reset();
		}
		
		public function YouAreAFailure() {
			return playerChips < 10;
		}
		
		public function ChipsLeft() {
			return playerChips > 0;
		}
		
		public function Disable() {
			if (dragRef) {if (dragRef.IsMoving()) {releaseCursor(null);}}
			chipsClickable = false;
			TweenMax.to(this,1,{alpha:0.3});
			TweenMax.to(ind,0.3,{alpha:0});
		}
		
		public function Enable() {
			chipsClickable = true;
			TweenMax.to(ind,0.3,{alpha:1});
			TweenMax.to(this,1,{alpha:1});
		}
		
		public function ManualAdd(amt:uint) {
			var denom:Array = [1000,500,100,25,10];
			var animate:Array = new Array();
			for (var i:uint;i<denom.length;i++) {	//build animation array
				if (denom[i] == 25 && playerChips%10 == 0) {continue;}
				while (ChipsLeft() && amt>=denom[i] && playerChips>=denom[i]) {
					//originRef = chips[];
					animate.push(chips[chips.length-1-i]);
					amt-=denom[i];
					playerChips-=denom[i];
				}
			}
			
			var temp:Chip;
			var delay:Number=0;
			
			for each (var key in animate) {		//animate the chips
				temp = new Chip(key.GetVal(),false,1,key);
				temp.x = this.x+key.x;
				temp.y = this.y+key.y;
				pot.Add(temp);
				Toggle(getChipDisplay());
				delay+=0.08;
			}
			
			trace(animate);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			for(var i=0;i<=4;i++) {	//initial chip placement
				chips[i].y=0;
				chips[i].x=i*chips[i].width;
				chips[i].addEventListener(MouseEvent.MOUSE_DOWN,captureCursor);
				this.addChild(chips[i]);
			}
			
			TweenPlugin.activate([AutoAlphaPlugin, VisiblePlugin]);
			this.x = (game.uiZone.width/2)-(this.width/2);
			this.y = game.uiZone.y+(game.uiZone.height/2)-(this.height/2);
			Toggle(getChipDisplay(),true);	//spawn chipUI according to initial chip count
			ind.y = this.height/2-ind.height/2;
		}
		
		private function getChipDisplay() {	//return chips to be animated
			var temp:Array = new Array();
			for (var i:uint=0;i<=4;i++) {
				if (chips[i].GetVal() > playerChips && chips[i].visible == true || chips[i].GetVal() <= playerChips && chips[i].visible == false) {
					temp.push(chips[i].GetVal());
				}
			}
			return temp;
		}
		
		public function HasDrag() {
			return dragRef.IsMoving();
		}
		
		private function captureCursor(e:MouseEvent){	//spawn dragged chip and store refs to it and the origin chip
			if (chipsClickable) {
				game.playSound("chip",1,6);
				originRef = chips[chips.indexOf(e.target.parent)];
				dragRef = new Chip(originRef.GetVal(),false,1,originRef);
				dragRef.x=this.x+originRef.x;
				dragRef.y=this.y+originRef.y;
				game.addChild(dragRef);
				playerChips-=dragRef.GetVal();
				dragRef.startDrag();
				dragRef.SetMoving(true);
				ind.Update(playerChips.toString());
				chipsClickable = false;
				Toggle(getChipDisplay());
				dragRef.addEventListener(MouseEvent.MOUSE_UP,releaseCursor);
				game.SaveStats();
			}
		}
		
		public function releaseCursor(e:MouseEvent){	//determine action based on chip position, chip back into pool or chip into pot
			if (dragRef != null) {
				if (dragRef.y > game.uiZone.y-dragRef.height) {	//cancel use of chip
					//ind.Update(playerChips.toString());
					playerChips+=dragRef.GetVal();
					fadingChips.reverse();	//timelinelite rocks
					Toggle(getChipDisplay());
					dragRef.SetMoving(false);
					TweenMax.to(dragRef,moveTime/2,{x:newXVal, y:this.y+originRef.y, onCompleteParams:[dragRef], onComplete:function(dragRef) {
						dragRef.parent.removeChild(dragRef);
						chipsClickable = true;
					}});
				}
				else {	//add chip to pot
					game.ResetTimer();
					dragRef.parent.removeChild(dragRef);
					pot.Add(dragRef);
					//game.removeChild(dragRef);
					chipsClickable = true;
				}
				trace("Chips left: "+playerChips);
				dragRef.stopDrag();
				dragRef.removeEventListener(MouseEvent.MOUSE_UP,releaseCursor);
				dragRef=null;
			}
			trace(pot.GetChips());
		}
		
		private function countUp() {	//fancy easing for pot counter
			//trace("player chips:"+playerChips+",last chips:"+ind.GetText());
			var _obj:Object = {};	
			_obj.newval = Number(ind.GetText());
			TweenMax.to(_obj, 3, {newval:Number(playerChips),ease:Regular.easeOut,onUpdate:updateInd,onUpdateParams:[_obj.newval]});
		}
		
		private function updateInd(val) {
			trace(val);
			ind.Update(val.toString());
		}
	
		private function Toggle(anim:Array,instant:Boolean=false) {	//does all the animation
			ind.Update(playerChips.toString());
			//countUp();
			if (playerChips < 10) {ind.Hide();}
			
			fadingChips = new TimelineLite();
			movingChips = new TimelineLite();
			
			for (var key in anim) {		//orient array refs based on passed chip values
				anim[key] = int(anim[key]);
				switch (anim[key]) {
					case 10:
						anim[key]=0;
						break;
					case 25:
						anim[key]=1;
						break;
					case 100:
						anim[key]=2;
						break;
					case 500:
						anim[key]=3;
						break;
					case 1000:
						anim[key]=4;
						break;
				}
			}
			
			for (var i:uint=0;i<=4;i++) {	//separate the chips to be animated by fading (too high for current chip total) from the ones to be animated through movement
				if (chips[i].visible == true && anim.indexOf(i) > -1) {	//if visible and in anim array, fade it out and don't animate
					if (instant) {
						chips[i].visible = false;
					}
					else {
						if (originRef == chips[i]) { //if the dragged chip is to be faded out, set visible to none instead. Illusion that this was the last chip of it's type to be spent
							chips[i].visible = false;
						}
						else {
							fadingChips.insert(new TweenMax(chips[i],fadeTime,{autoAlpha:0,ease:Linear}));
						}
					}
					anim.splice(anim.indexOf(i),1);
				}
				else if (chips[i].visible == true && anim.indexOf(i) == -1) { //if visible and not in movement animation, add it
					anim.push(i);
				}
			}
			anim.sort(Array.NUMERIC);	//make sure they're in the right order

			for (i=0;i<anim.length;i++) {
				if (instant) {	//move chips instantly
					this.x = (game.uiZone.width/2)-(anim.length*chips[0].width/2);
					chips[anim[i]].x = chips[0].width*i;
					if (chips[anim[i]].visible == false) {
						chips[anim[i]].visible == true;
					}
				}
				else {	//animate movements based on moveTime and fades based on fadeTime
					movingChips.insert(new TweenMax(this,moveTime,{x:(game.uiZone.width/2)-(anim.length*chips[0].width/2),roundProps:["x"]}));
					movingChips.insert(new TweenMax(chips[anim[i]],moveTime,{x:chips[0].width*i,ease:Linear,roundProps:["x"]}));
					
					if (chips[anim[i]] == originRef) {
						newXVal = (game.uiZone.width/2-anim.length*chips[0].width/2)+(chips[0].width*(i));	//predict new xVal to return dragRef to originRef
						
						if (chips[anim[i]].visible == false) {
							fadingChips.insert(new TweenMax(chips[anim[i]],0,{autoAlpha:1,delay:moveTime}));
						}
					}
					else if (chips[anim[i]].visible == false) {
						fadingChips.insert(new TweenMax(chips[anim[i]],fadeTime,{autoAlpha:1,ease:Linear}));
					}
				}
			}
		}
	}
}