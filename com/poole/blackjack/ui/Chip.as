package com.poole.blackjack.ui {
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.display.*;
	import flash.utils.getDefinitionByName;

	public class Chip extends MovieClip {
		private var val:uint;
		private var size;
		private var bmpRef:DisplayObject;
		private var allowMove:Boolean=false;
		private var isMoving:Boolean=false;
		private var origin:Chip;
		
		public function Chip(v:uint,aMove:Boolean=false,siz:Number=1,orig:Chip=null) {
			origin=orig;
			val=v;
			size=siz;
			allowMove=aMove;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var classDefinition:Class = Class(getDefinitionByName("Chip_"+val));
			bmpRef = new classDefinition();
			bmpRef.scaleX*=size;
			bmpRef.scaleY*=size;
			this.addChild(bmpRef);
			addEventListener(MouseEvent.MOUSE_DOWN,captureCursor);
		}

		public function GetVal() {
			return val;
		}
		
		public function Moveable() {
			return allowMove;
		}
		
		public function IsMoving() {
			return isMoving;
		}
		
		public function SetMoving(e:Boolean) {
			isMoving = e;
		}
		
		public function AllowMove(a:Boolean) {
			allowMove=a;
		}
		
		public function GetOrigin() {
			return origin;
		}
		
		private function captureCursor(e:MouseEvent){
			if (allowMove) {
				isMoving=true;
				e.target.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP,releaseCursor);
			}
		}
			
		private function releaseCursor(e:MouseEvent){
			isMoving=false;
			e.target.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP,releaseCursor);
		}
	}
	
}
