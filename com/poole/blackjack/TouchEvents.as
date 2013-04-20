package com.poole.blackjack {
	import flash.events.*;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.net.Responder;
	
	public class TouchEvents extends EventDispatcher {
		private var fingerX:int;
		private var fingerY:int;
		private var target:Object;
		private var action:String;	//sets the action to be carried to touchend
		private var points:Array = new Array();		//tracks multiple touch points
		private var distinct:Boolean = false;	//determines whether or not there are any touch interactions
		
		public function TouchEvents(tar) {
			target=tar;
			target.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
			target.addEventListener(TouchEvent.TOUCH_MOVE,onTouchMove);
			target.addEventListener(TouchEvent.TOUCH_END,onTouchEnd);
		}
		
		private function onTouchBegin(e:TouchEvent) {
			fingerX = e.stageX;
			fingerY = e.stageY;
			points[e.touchPointID] = e;
			distinct = true;	//new touch interaction
			if (enumPoints() == 2) {trace("2 points");}
			trace(enumPoints());
		}
		
		private function onTouchMove(e:TouchEvent) {
			if (enumPoints() == 1) {		//single point touch event
				if (e.stageX > (fingerX+150) && (e.stageY > (fingerY-100) && e.stageY < (fingerY+100))) {	// swipe right
					action = "sr";
				}
				else if(e.stageX < (fingerX-150) && (e.stageY > (fingerY-100) && e.stageY < (fingerY+100))) { 	// swipe left
					action = "sl";
				}
				else if(e.stageY < (fingerY-150) && (e.stageX > (fingerX-100) && e.stageX < (fingerX+100))) { 	// swipe up
					action = "su";
				}
				else if(e.stageY > (fingerY+150) && (e.stageX > (fingerX-100) && e.stageX < (fingerX+100))) { 	// swipe down
					action = "sd";
				}
			}
			if (enumPoints() == 2) {	//2-point touch event
				trace("2 points moving");
			}
		}
	
		private function onTouchEnd(e:TouchEvent) { 	// e.touchPointID;
			points[e.touchPointID]=null;
			if (enumPoints() == 0) {distinct = false; points = new Array()}		//touch interaction ended
			if (e.stageX > (fingerX-40) && e.stageX < (fingerX+40) && e.stageY < (fingerY+40) && e.stageY > (fingerY-40)) {
				trace("clicked");
				dispatchEvent(new MouseEvent(MouseEvent.CLICK,true,false,e.stageX,e.stageY));
			}
			else {
				switch (action) {
					case "sr":
						dispatchEvent(new Event("SwipeRight"));
						trace("swiped right");
						break;
					case "sl":
						dispatchEvent(new Event("SwipeLeft"));
						trace("swiped left");
						break;
					case "su":
						dispatchEvent(new Event("SwipeUp"));
						trace("swiped up");
						break;
					case "sd":
						dispatchEvent(new Event("SwipeDown"));
						trace("swiped down");
						break;
				}
			}
    	}
		
		private function enumPoints() {
			var i:uint = 0;
			for each (var key in points) {
				if (key != null) {i++;}
			}
			return i;
		}
	}
}
