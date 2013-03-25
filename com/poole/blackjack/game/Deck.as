package com.poole.blackjack.game {
	import flash.events.*;
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.*;
	
	public class Deck extends MovieClip {
		var values:Array = new Array("A","2","3","4","5","6","7","8","9","1","J","Q","K");
		var suits:Array = new Array("D","C","H","S");
		var deck:Array = new Array();
		var played:Array = new Array();
		var bmp:Array = new Array();
		var game;
		var cardSize:Number;
		var tempCard:Card;
		
		public function Deck(gameRef,size:Number=1) {
			game=gameRef;
			cardSize=size;
			var cards:Bitmap = new Bitmap(new Cards());
			var x:uint=0,y:uint=0;
			
			deck = new Array();
			for (var index1 in suits) {
				for (var index in values) {		//build deck array
					if (y==0) {bmp[values[index]+suits[index1]]=cropBitmap(x*371+x*10+10,y*521+y*10+10,370,518,cards);}
					if (y==1) {bmp[values[index]+suits[index1]]=cropBitmap(x*371+x*10+10,y*521+y*10+7,370,518,cards);}		//split deck bitmap into individual card bitmaps
					if (y==2) {bmp[values[index]+suits[index1]]=cropBitmap(x*371+x*10+10,y*521+y*10+5,370,518,cards);}
					if (y==3) {bmp[values[index]+suits[index1]]=cropBitmap(x*371+x*10+10,y*521+y*10+2,370,518,cards);}
					bmp[values[index]+suits[index1]].scaleX=0.5;
					bmp[values[index]+suits[index1]].scaleY=0.5;
					deck.push(values[index]+suits[index1]);
					x+=1;
					if (x==13) {
						y+=1;
						x=0;
					}
				}
			}
			tempCard = new Card(bmp[deck[0]],deck[0],true,true,size)
			Shuffle();
		}
		
		public function Reset() {
			deck = new Array();
			for each (var index in suits) {
				for each (var index1 in values) {		//build deck array
					deck.push(index1+index);
				}
			}
			Shuffle();
			played = new Array();
		}
		
		public function Peek(n:uint=0):Array {
			if (n != 0) {
				var temp:Array = new Array();
				for (var i:uint=0;i<n;i++) {
					temp.push(deck[i]);
				}
				return temp;
			}
			else {
				return deck;
			}
		}
		
		public function CardsLeft() {
			return deck.length;
		}
		
		public function Shuffle() {
			var temp:Array = new Array(deck.length);
			var randomPos:uint = 0;
			
			for (var i:int = 0; i < temp.length; i++) {    
				randomPos = int(Math.random() * deck.length);    
				temp[i] = deck[randomPos];
				deck.splice(randomPos, 1);
			}
			deck=temp;
		}
		
		public function Draw(flipped:Boolean=true,allowMove:Boolean=false,give:String=null) {
			if (deck.length == 0) {return 0;}
			var card;
			if (give != null) {
				for (var index in deck) {
					if (deck[index].charAt(0) == give) {
						card = new Card(bmp[deck[index]],deck[index],flipped,allowMove,cardSize);
						deck.splice(index,1);
						break;
					}
					if (index == deck.length-1) {
						card = new Card(bmp[deck[0]],deck[0],flipped,allowMove,cardSize);
						deck.splice(0,1);
					}
				}
			}
			else {
				card = new Card(bmp[deck[0]],deck[0],flipped,allowMove,cardSize);
				deck.splice(0,1);
			}
			
			played.push(card);
			//game.addChild(card);
			//this.parent.addChild(card);
			return card;
			
			/*var ret:Array = new Array();
			var tmpCard:Card;
			for (var i:uint=0;i<n;i++) {
				if (deck.length > 0) {
					tmpCard = new Card(deck[0]);
					ret.push(tmpCard);
					deck.splice(0,1);
				}
				else {
					return 0;
				}
			}
			
			return ret;*/
		}
		
		public function CardProps() {
			return tempCard.GetBmp();
		}
		
		private function cropBitmap( _x:Number, _y:Number, _width:Number, _height:Number, displayObject:DisplayObject = null):Bitmap {
		   var cropArea:Rectangle = new Rectangle( 0, 0, _width, _height );
		   var croppedBitmap:Bitmap = new Bitmap( new BitmapData( _width, _height, true, 0x00ffffff ), PixelSnapping.ALWAYS, true );
		   croppedBitmap.bitmapData.draw( (displayObject!=null) ? displayObject : stage, new Matrix(1, 0, 0, 1, -_x, -_y) , null, null, cropArea, true );
		   return croppedBitmap;
		}
		
		public function GetPlayed() {
			return played;
		}
	}
}

import flash.events.*;
import flash.display.*;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.*;
	
class Card extends MovieClip {
	private var dis:String;	//displayed value (A,2-9,1,J,Q,K)
	private var num:Number;	//numeric value	(1,2-9,10,10,10,10)
	private var suit:String;
	private var owner:String;
	private var flip:Boolean;
	private var bmpRef:DisplayObject;
	private var backRef:DisplayObject = new Bitmap(new Backer());
	private var isMoving:Boolean=false;
	private var allowMove:Boolean=false;
	private var size:Number;
	
	public function Card(bmp,passVal:String,flipped:Boolean=true,aMove:Boolean=false,siz:Number=1) {
		bmpRef=bmp;
		size=siz;
		allowMove=aMove;
		flip=flipped;
		dis=passVal.charAt(0);
		suit=passVal.charAt(1);
		num=getLocalNumericValue(dis);
		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(e:Event) {
		removeEventListener(Event.ADDED_TO_STAGE, init);
		backRef.scaleX=0.5*size;
		backRef.scaleY=0.5*size;
		bmpRef.scaleX*=size;
		bmpRef.scaleY*=size;
		this.addChild(bmpRef);
		this.addChild(backRef);
		addEventListener(MouseEvent.MOUSE_DOWN,captureCursor);
		if (flip) {backRef.visible=false;}
		else {bmpRef.visible=false;}
	}
	
	private function captureCursor(e:MouseEvent){
		if (Moveable()) {
			isMoving=true;
			stage.addEventListener(MouseEvent.MOUSE_UP,releaseCursor);
			e.target.startDrag();
		}
	}
		
	private function releaseCursor(e:MouseEvent){
		isMoving=false;
		e.target.stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP,releaseCursor);
	}
	
	private function getLocalNumericValue(val:String):Number {
		if ((val.charCodeAt(0) >= 48 && val.charCodeAt(0) <= 57) && val.charCodeAt(0) != 49) {	//2-9
			return int(val);
		}
		else if (val.charCodeAt(0) == 74 || val.charCodeAt(0) == 75 || val.charCodeAt(0) == 81 || val.charCodeAt(0) == 49) {	//jack, king, queen, 10
			return 10;
		}
		else {
			return 11;	//ace
		}
	}
	
	public function Flip(stat:Boolean) {
		flip=stat;
		if (flip) {
			bmpRef.visible = true;
			backRef.visible = false;
		}
		else {
			backRef.visible = true;
			bmpRef.visible = false;
		}
	}
	
	public function Flipped() {
		return flip;
	}
	
	public function DisplayValue() {
		return dis;
	}
	
	public function NumericValue() {
		return num;
	}
	
	public function Suit() {
		return suit;
	}
	
	public function SetOwner(pass:String) {
		owner=pass;
	}
	
	public function Owner() {
		return owner;
	}
	
	public function IsMoving() {
		return isMoving;
	}
	
	public function toggleMove(a:Boolean) {
		allowMove=a;
	}
	
	public function Moveable() {
		return allowMove;
	}
	
	public function Resize(siz:Number) {
		size*=siz;
		backRef.scaleX*=size;
		backRef.scaleY*=size;
		bmpRef.scaleX*=size;
		bmpRef.scaleY*=size;
	}
	
	public function GetBmp() {
		return bmpRef;
	}
}
