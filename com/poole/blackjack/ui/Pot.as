package com.poole.blackjack.ui {
	import flash.display.MovieClip;
	import com.poole.blackjack.ui.Chip;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;

	public class Pot extends MovieClip {
		private var chips:Array = new Array();
		private var total:uint = 0;
		private var game;	//parent refs
		private var chipUI;
		private var moveTime:Number=0.7;	//used in animation
		private var chipSpace:uint=2;	//determines how far apart each chip is
		private var nextX:uint;		//set expected X of last added chip, used for animation of a chip if the last hasn't finished animating yet
		private var chipVals:Array = new Array();	//stores sorted chip refs
		
		public function Pot(gam) {
			game = gam;
			game.addChildAt(this,game.numChildren);
			Reset();
		}
		
		public function Add(chip:Chip) {
			if ((chips.length)*(chip.width/chipSpace)+chip.width*2 > game.gestureZone.width) {
				shiftChips()
			}
	
			if (chips.length < 1) {this.y=game.gestureZone.height/2-chip.height/2; this.x=game.gestureZone.width/2-chip.width/2}	//set initial y
			chips.push(chip);
			chipVals[chip.GetVal()].push(chips.length-1);
			chip.AllowMove(false);
			total += chip.GetVal();
			
			this.addChild(chip);
			chip.scaleX = 1/this.scaleX;
			chip.y=chip.y-this.y;	//correct for new parent space
			chip.x=chip.x-this.x;
			
			if (chips.length == 1) {
				TweenMax.to(chip,moveTime,{x:0,y:0});
				nextX = chip.width/chipSpace;
			}
			else {
				TweenMax.to(chip,moveTime,{x:nextX,y:0});
				nextX = chips.length*(chip.width/chipSpace);
			}
			TweenMax.to(this,moveTime,{x:game.gestureZone.width/2-((chip.width/chipSpace)*(chips.length+1))/2});
		}
		
		private function shiftChips() {
			chipSpace += 1;
			var temp:uint=0;
			for (var i in chips) {
				if (i != 0) {
					temp+=chips[0].width/chipSpace;
					TweenMax.to(chips[i],moveTime,{x:temp});
				}
			}
			nextX = chips.length*(chips[0].width/chipSpace);
		}
		
		public function Reset() {
			chips = new Array();
			chipVals[1000] = new Array();
			chipVals[500] = new Array();
			chipVals[100] = new Array();
			chipVals[25] = new Array();
			chipVals[10] = new Array();
			total = 0;
			chipSpace=2;
		}
		
		public function Award(num:uint) {	//animates highest denomination chips from pot for award, returns remainder to be awarded if not enough chips
			var rem:int = num-total;
			if (num > total) {num = total;}
			var denom:Array = [1000,500,100,25,10];
			var animate:Array = new Array();
			var animate1:Array = new Array();
			var track:uint = num;
			
			for each (var key in denom) {
				//if (key == 25 && num%10 == 0) {continue;}	//skip 25 if num is already even
				while (chipVals[key].length > 0) { 
					if (num >= key && !(key == 25 && num%10 == 0)) { //build player award array
						animate.push(chips[chipVals[key][chipVals[key].length-1]]);
						num -= key;
					}
					else if (num < key || (key == 25 && num%10 == 0)) {animate1.push(chips[chipVals[key][chipVals[key].length-1]]);}	//build house award array
					chipVals[key].pop();
				}
				//if (num <= 0) {break;}
			}
			
			var temp:Chip;
			var delay:Number=0;
				
			for(key in animate) {	//animate player chips
				temp = animate[key].GetOrigin();
				/*if (key > 0) {
					if (animate[key].GetVal() != animate[key-1].GetVal()) {delay=0;}	//reset delay for each chip value
				}*/
				
				chipUI.AddToChips(animate[key].GetVal());

				TweenMax.to(animate[key],moveTime,{	//animate chips awarded to player
							delay:delay,
							x:chipUI.x+temp.x-this.x,
							y:chipUI.y+temp.y-this.y,
							roundProps:["x","y"],
							onComplete:function(chipRef) {
								chipRef.parent.removeChild(chipRef);
							},
							onCompleteParams:[animate[key]]
				});
				delay+=0.08;
			}
			
			//delay=0;
			for(key in animate1) {	//animate house chips
				temp = animate1[key].GetOrigin();
				/*if (key > 0) {
					if (animate[key].GetVal() != animate[key-1].GetVal()) {delay=0;}	//reset delay for each chip value
				}*/

				TweenMax.to(animate1[key],moveTime,{	//animate chips awarded to player
							delay:delay,
							x:this.width/2,
							y:this.y-stage.stageHeight,
							roundProps:["x","y"],
							onComplete:function(chipRef) {
								chipRef.parent.removeChild(chipRef);
							},
							onCompleteParams:[animate1[key]]
				});
				delay+=0.08;
			}

			trace("Chips left: "+chipUI.GetChips());
			Reset();
			if (rem > 0) {chipUI.AddToChips(rem);}
		}
		
		public function GetChips() {
			return total;
		}
		
		public function SetChipUI(ui) {
			chipUI =ui;
		}
	}
}
